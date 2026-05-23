class_name Verdano
extends Enemy
var snail_speed = 10
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
	super._init(pos,Rect2(-4,0,8,4))
	offset = Vector2(0,0)
	dmg_source_name = "Verdano Canopio"
	Health = 300
	MaxHealth = 300
	navigator = NavigationAgent2D.new()
	navigator.radius = 64
	#navigator.debug_enabled = true
	navigator.avoidance_enabled = true
	navigator.path_desired_distance = 4.0
	navigator.target_desired_distance = 0.0
	add_child(navigator)
	var detection_range:Area2D = Area2D.new()
	Utils.attach_round_collision_shape(detection_range,128,on_detect,Vector2(-2,0))
	
	var leave_range:Area2D = Area2D.new()
	Utils.attach_round_collision_shape(leave_range,128,null,Vector2(-2,0))
	leave_range.connect("body_exited",leave_detect)
	
	add_child(detection_range)
	add_child(leave_range)

var head_switch_delay = 0
const head_switch_delay_MAX = 0.3
var switching = false
func _process(delta: float) -> void:
	super._process(delta)
	var plr:Player = Main.main.get_player()
	if old_facing != facing and not switching:
		switching = true
	if switching:
		head_switch_delay += delta
		if head_switch_delay >= head_switch_delay_MAX:
			head_switch_delay = 0
			switching = false
	if plr and plr.position.distance_to(position) < 640:
		set_movement_target(plr.position)
		kb_dir = position.direction_to(plr.position)
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
	if chasing:
		position += delta * final_vel * (snail_speed * (1 + float(Main.main.get_peril())/Main.MAX_PRL))

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
	if not body_dict or not head_dict: return
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
	draw_from_dict(head_dict,offset + bobbing_offset,head_spr_index_offset)
	var plr = Main.main.get_player()
	if not switching:
		var eyes = [Vector2(4,-9 + bobbing_offset.y),Vector2(-4,-11 + bobbing_offset.y),Vector2(12,-11 + bobbing_offset.y)]
		for eye in eyes:
			draw_circle(eye + position.direction_to(plr.position),1,Main.colors[2], true,0)
	else:
		var eyes = [Vector2(-3,-9 + bobbing_offset.y),Vector2(11,-9 + bobbing_offset.y)]
		for eye in eyes:
			draw_circle(eye + position.direction_to(plr.position),1,Main.colors[2], true,0)
	if chasing:
		Main.draw_text(self,"!", Vector2(0,-30),Main.colors[8],Main.colors[0],false,true)
