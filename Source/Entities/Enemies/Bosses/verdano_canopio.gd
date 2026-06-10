class_name Verdano
extends Enemy
var snail_speed = 20
var current_agent_position: Vector2
var next_path_position: Vector2
var kb_dir:Vector2
var chasing = false
var old_facing = Vector2(0,0)
var facing = Vector2(0,0)
var head_dict:Dictionary[int,Vector2]={
	85:Vector2(-1,-1),
	86:Vector2(0,-1),
	87:Vector2(1,-1),
	69:Vector2(-1,-2),
	70:Vector2(0,-2),
	71:Vector2(1,-2),
}
var body_dict:Dictionary[int,Vector2]={
	101:Vector2(-1,0),
	102:Vector2(0,0),
	103:Vector2(1,0),
}
func _init(pos) -> void:
	super._init(pos,Rect2(4,0,8,4))
	draw_offset = Vector2(0,-4)
	dmg_source_name = "Verdano Canopio"
	Health = 300
	MaxHealth = 300
	navigator = NavigationAgent2D.new()
	navigator.radius = 64
	peril_penalty = 20
	#navigator.debug_enabled = true
	navigator.avoidance_enabled = true
	navigator.path_desired_distance = 4.0
	navigator.target_desired_distance = 0.0
	add_child(navigator)
	var detection_range:Area2D = Area2D.new()
	Utils.attach_round_collision_shape(detection_range,128,on_detect,Vector2(0,0))
	
	var leave_range:Area2D = Area2D.new()
	Utils.attach_round_collision_shape(leave_range,128,null,Vector2(0,0))
	leave_range.connect("body_exited",leave_detect)
	
	add_child(detection_range)
	add_child(leave_range)

var head_switch_delay = 0
const head_switch_delay_MAX = 0.3
var switching = false
enum Attacks {
	Idle,
	PoisonOrb,
	Rooting,
	Rush,
}
var current_attack:Attacks = Attacks.Idle
var attack_timer:float = 0
var counter = 0
var moving = false
const porb_delay:float = 1
const weed_grow_delay:float = 2
const rush_delay:float = 1.5
func _process(delta: float) -> void:
	name = "verdano"
	super._process(delta)
	var plr:Player = Main.main.get_player()
	var lvl = Main.main.get_level()
	attack_timer += delta * (1 + max(0, 0.2 - (2.0 * Main.main.perilcent)))
	if old_facing != facing and not switching:
		switching = true
	if current_attack == Attacks.Rush:
		switching = Utils.blink(true,false,2 + (12 * attack_timer/rush_delay))
	if switching:
		head_switch_delay += delta
		if head_switch_delay >= head_switch_delay_MAX:
			head_switch_delay = 0
			switching = false
	if moving and (plr and plr.position.distance_to(position) < 640):
		set_movement_target(plr.position)
		kb_dir = position.direction_to(plr.position)
	match current_attack:
		Attacks.Idle:
			moving = true
			if attack_timer > 7:
				current_attack = Attacks.PoisonOrb if Utils.maybe() else Attacks.Rush
				moving = false
				attack_timer = 0
		Attacks.PoisonOrb:
			moving = false
			facing = Vector2(0,1)
			if attack_timer > porb_delay:
				shoot_orb(plr.position)
				shoot_orb(plr.position,0.2,randf_range(-60,60))
				shoot_orb(plr.position,0.2,randf_range(-60,60))
				current_attack = Attacks.Rooting
				attack_timer = 0
		Attacks.Rush:
			if counter == 0 and attack_timer > weed_grow_delay:
				hitcount = 0
				set_movement_target(plr.position)
				kb_dir = position.direction_to(plr.position)
				attack_timer = 0
				counter = 1
				moving = true
			if counter >= 1:
				moving = true
				if Engine.get_frames_drawn() % 6 == 0:
					shoot_seed(plr.position)
				set_movement_target(plr.position)
				kb_dir = position.direction_to(plr.position)
				snail_speed = 40
				var rush_max = 2 + (4 * (Main.main.get_peril()/Main.MAX_PRL))
				if attack_timer >= rush_max:
					counter = 0
					snail_speed = 20
					current_attack = Attacks.Rooting
					attack_timer = 0
		Attacks.Rooting:
			moving = false
			if counter == 0 and attack_timer > weed_grow_delay:
				hitcount = 0
				for i in range(3):
					for j in range(3):
						if (i == 0 or i == 2) and (j == 0 or j == 2):
							continue
						var twig_x = (i - 1) * 8
						var twig_y = (j - 1) * 8
						lvl.enemies.add_child.call_deferred(TwigPile.new((position + Vector2(twig_x + (twig_x % 8),twig_y + (twig_y % 8)))))
				attack_timer = 0
				counter += 1
			if counter >= 1 and attack_timer > 1.1:
				var weed_array:Array[Snitchweed]
				for i in range(counter-1):
					for j in range(counter-1):
						if (i == 0 or i == counter-2) or (j == 0 or j == counter-2):
							var weed_x = (i - 1) * 8
							var weed_y = (j - 1) * 8
							weed_array.append(Snitchweed.new((position + Vector2(weed_x + (weed_x % 8),weed_y + (weed_y % 8)) )))
				
				for i in range(counter):
					if not weed_array.is_empty():
						var chosen_weed = weed_array.pick_random()
						lvl.traps.add_child.call_deferred(chosen_weed)
						weed_array.erase(chosen_weed)
				counter += 1
				attack_timer = 0
				if counter > 6:
					counter = 0
					current_attack = Attacks.Idle
					attack_timer = 0
					
var hitcount = 0
const hits_for_twigpile = 4
const base_hits_for_rootskip = 6
func hurt(value:int,source,iframe_override=IFRAMES):
	if not super(value,source,iframe_override): return false
	if current_attack != Attacks.Rooting:
		hitcount += 1
		if hitcount > hits_for_twigpile:
			hitcount = 0
			var lvl = Main.main.get_level()
			lvl.enemies.add_child.call_deferred(TwigPile.new(position + Vector2(int(position.x) % 8,int(position.y) % 8)))
	elif counter >= 1:
		attack_timer -= 0.15
		hitcount += 1
		if hitcount > base_hits_for_rootskip:
			moving = true
			hitcount = 0
			counter = 0
			current_attack = Attacks.Idle
			attack_timer = 0

func vanquish():
	super()
	var lvl = Main.main.get_level()
	lvl.drop_item_somewhere(position,Trophy1)


func _physics_process(delta):
	if navigator.is_navigation_finished():
		return
	old_facing = facing
	current_agent_position = position
	next_path_position = navigator.get_next_path_position()
	queue_redraw()
	var final_vel = current_agent_position.direction_to(next_path_position)
	if abs(final_vel.x) > abs(final_vel.y) and facing != Vector2(1,0) * sign(final_vel.x):
		facing = Vector2(1,0) * sign(final_vel.x)
	if abs(final_vel.x) <= abs(final_vel.y) and facing != Vector2(0,1) * sign(final_vel.y):
		facing = Vector2(0,1) * sign(final_vel.y)
	if chasing and moving:
		position += delta * final_vel * (snail_speed * (1 + float(Main.main.get_peril())/Main.MAX_PRL))

func shoot_orb(target:Vector2, shoot_speed:float=0.5, rot:float=0):
	var origin:Vector2 = position
	PoisonOrb.new(self,origin,(origin.direction_to(target) * shoot_speed).rotated(deg_to_rad(rot)),7)
func shoot_seed(target:Vector2):
	var origin:Vector2 = position
	var proj = BerrySeed.new(self,origin,origin.direction_to(target) * 0,10)
	proj.lifetime = 10
func on_touch_thing(body):
	if body is Player:
		body.knockback(kb_dir, 200)
		body.hurt(20,self)
func on_detect(body: Node2D) -> void:
	if body is Player:
		chasing = true
func leave_detect(body: Node2D) -> void:
	if body is Player:
		chasing = false

func _draw() -> void:
	super()
	if not body_dict or not head_dict: return
	var head_pos_offset:Vector2 = Vector2(0,0)
	for index in body_dict.keys():
		var spr_index_offset = 0
		var extra_offset = Vector2(0,0)
		if facing == Vector2(1,0):
			spr_index_offset += 16
			if index == 101: extra_offset = Vector2(16,0)
			if index == 103: continue
		if facing == Vector2(-1,0):
			spr_index_offset += 16
			if index == 103: continue
		if index == 102:
			spr_index_offset += Utils.blink(Utils.blink(2,3,24),0,12)
		var flipXval = Vector2(1,1) if facing == Vector2(-1,0) else Vector2(-1,1)
		if facing.y != 0: flipXval = Vector2(1,1)
		Main.spr(Main.GameAtlas,self, extra_offset + (offset) + (body_dict.get(index)) * (Main.SPR_SIZE),spr_index_offset + index,Main.colors[7],flipXval)
	var head_spr_index_offset = 0 if not switching else 3
	var bobbing_offset = Vector2(0,sin(Engine.get_frames_drawn() * 0.1) + 1)
	var plr = Main.main.get_player()
	if current_attack == Attacks.Rooting:
		if counter >= 1:
			head_pos_offset.y =  8
		else:
			head_pos_offset.y = lerp(0,8,attack_timer/weed_grow_delay)
	elif current_attack == Attacks.Rush:
		draw_line(position,plr.position,Main.colors[2])
		if counter >= 1:
			head_pos_offset.y =  8
		else:
			head_pos_offset.y = lerp(0,8,attack_timer/rush_delay)
	var finaL_pos = offset + bobbing_offset + head_pos_offset
	draw_from_dict(head_dict,finaL_pos,head_spr_index_offset)
	if not switching:
		var eyes = [Vector2(4,-9),Vector2(-4,-11),Vector2(12,-11)]
		for eye in eyes:
			draw_circle(eye + finaL_pos + position.direction_to(plr.position),1,Main.colors[2])
	else:
		var eyes = [Vector2(-3,-9 + bobbing_offset.y + head_pos_offset.y),Vector2(11,-9 + bobbing_offset.y + head_pos_offset.y)]
		for eye in eyes:
			draw_circle(eye + position.direction_to(plr.position),1,Main.colors[2])
	if chasing:
		Main.draw_text(self,"!", Vector2(0,-30),Main.colors[8],Main.colors[0],false,true)
