extends Actor
class_name Player

var Center:
	get: return position - (size / 2) + Vector2(0,2)
const SPEED = 45.0
var direction:Vector2
var facing: Vector2
var spr_index = 0
var sneaking:bool = false
var running:bool = false
var health:int=100
var max_health:int = 100
var current_stamina:float = 100
const IFRAMES = 0.2
var iframe_timer:float = 0
var kb_override = false
var kb_override_vector:Vector2
var no_control = false
var no_draw = false
@onready var camera:Camera2D = $Camera2D
@onready var point_light_2d: PointLight2D = $InnerLight
var throwmode:bool = false
var might_interact = false

var effects:Dictionary[Effect,int]
var damage_mult = 1

func _ready() -> void:
	#z_index = Main.Depths.Player
	kb_override = false
	width = 8
	height = 8
	Main.main.resources.inv_selected = 0
	pass
	
var prevent_holding_atk = false
var refill_delay = 0
var refill_delay_max = 3.0
func _process(delta: float) -> void:
	point_light_2d.enabled = Main.main.current_level.id != LevelID.Above
	if point_light_2d.enabled:
		point_light_2d.texture_scale = 0.4 + (sin(Engine.get_frames_drawn() * 0.05) * 0.01 )
	if running:
		refill_delay = 0
		current_stamina = clampf(current_stamina - delta * 25,0,health)
	else:
		refill_delay += delta
		if refill_delay >= refill_delay_max:
			refill_delay = refill_delay_max
			current_stamina = clampf(current_stamina + delta * 10,0,health)
	if iframe_timer > 0:
		iframe_timer = clampf(iframe_timer - delta,0,IFRAMES)
	if Main.main.resources.inventory.size() > 0:
		var item = Main.main.resources.get_selected_item()
		var holding_atk = Input.is_action_pressed("accept")
		if item and not might_interact and (not prevent_holding_atk and holding_atk):
			item.on_use()
	if no_draw: return
	queue_redraw()
var snap_pos

var positive_speed_mod = 0
var negative_speed_mod = 0
var final_speed_mod = 0
func _physics_process(delta: float) -> void:
	snap_pos = Vector2(int(position.x) % 8 * 8,int(position.y) % 8 * 8)
	#camera.rotation = get_angle_to(position + direction)
	camera.zoom = Vector2(1,1) if not Main.main.debugmode else Vector2(0.25,0.25)
	direction = Input.get_vector("left", "right", "up", "down")
	sneaking = Input.is_action_pressed("sneak")
	running = Input.is_action_pressed("run") and current_stamina > 0
	sneaking = sneaking && !running
	if kb_override_vector.length() <= 0:
		if direction:
			facing = direction
			if no_draw: return
			queue_redraw()
			velocity = direction * (SPEED * final_speed_mod) * (1.9 if running and not sneaking else (1.0 if not sneaking else 0.4))
		else:
			negative_speed_mod = 0
			positive_speed_mod = 0
			var mevent:MoveEvent = MoveEvent.new(0,self)
			if mevent.speedmod < 0:
				if abs(mevent.speedmod) > negative_speed_mod:
					negative_speed_mod = abs(mevent.speedmod)
			else:
				if abs(mevent.speedmod) > positive_speed_mod:
					positive_speed_mod = abs(mevent.speedmod)
			final_speed_mod = 1 + (positive_speed_mod - negative_speed_mod)
			velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	else:
		kb_override_vector = kb_override_vector.move_toward(Vector2.ZERO, SPEED * .25)
		velocity = kb_override_vector
		if kb_override_vector.length() <= 0:
			kb_override_vector = Vector2.ZERO
			kb_override = false
	if no_control or throwmode:
		velocity = Vector2.ZERO
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debugmode"):
		Main.main.debugmode = !Main.main.debugmode
		get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS if Main.main.debugmode else Window.CONTENT_SCALE_MODE_VIEWPORT
	if no_control:
		return
	if not throwmode and event.is_action_pressed("inventory") and Main.main.current_level.id != LevelID.Above:
		Main.main.inventory_open = not Main.main.inventory_open
	var item := Main.main.resources.get_selected_item()
	if item and not might_interact:
		if Main.main.inventory_open and not throwmode and event.is_action_pressed("throw"):
			throw()
		elif event.is_action_pressed("accept"):
			prevent_holding_atk = not item.item_auto
			item.on_use()
	if event.is_action_pressed("skip_hymn") and Main.main.inventory_open:
		Main.main.disc_manager.skip_next()
	if not throwmode:
		if (event.is_action_pressed("inv_left") or event.is_action_pressed("inv_right")):
			var input = Input.get_axis("inv_left","inv_right")
			prevent_holding_atk = true
			if Main.main.resources.inv_selected + int(input) <= -1 and input == -1:
				Main.main.resources.inv_selected = 14
				while not Main.main.resources.get_selected_item():
					Main.main.resources.inv_selected += int(input)
			else:
				Main.main.resources.inv_selected += int(input)
				if not Main.main.inventory_open:
					while not Main.main.resources.get_selected_item():
						Main.main.resources.inv_selected += int(input)
		if Main.main.inventory_open and (event.is_action_pressed("inv_up") or event.is_action_pressed("inv_down")):
			var input = Input.get_axis("inv_up","inv_down")
			prevent_holding_atk = true
			if Main.main.resources.inv_selected + int(input) * 5 <= -1 and input == -1:
				Main.main.resources.inv_selected += 10
			else: Main.main.resources.inv_selected += int(input) * 5

func _draw() -> void:
	#Main.main.draw_text_centered(self,"hi pearlings", (Vector2(0,-32)))
	#Main.main.draw_text_centered(self,"centered text", (Vector2(0,-24)))
	#Main.main.draw_text("uncentered text", (Vector2(0,-16)))
	
	if no_draw: return
	if facing:
		spr_index = (1 if facing.x > 0 else 3) if facing.x != 0 else (2 if facing.y < 0 else 0)
		if direction:
			#spr_index += Utils.blink(131,147,12)
			spr_index += Utils.blink(0,Utils.blink(131,147,12),6)
	if floori(iframe_timer * 100.0) % 4 == 0 and iframe_timer < IFRAMES:
		Main.spr(Main.GameAtlas,self,-size/2,spr_index)

func hurt(value, hurter:Entity):
	if iframe_timer > 0 or no_control or value == 0: return
	var devent:DamageEvent = DamageEvent.new(value,self,hurter)
	iframe_timer = IFRAMES
	health -= devent.damage
	print("player hurt for %s" % devent.damage)
	if health <= 0:
		Main.main.killed_by = hurter.dmg_source_name
		Main.main.trigger_game_over.call_deferred()

func hurt_hurter_freed(value, hurter_name:String):
	if iframe_timer > 0 or no_control or value == 0: return
	var devent:DamageEvent = DamageEvent.new(value,self,null)
	iframe_timer = IFRAMES
	health -= devent.damage
	print("player hurt for %s" % devent.damage)
	if health <= 0:
		Main.main.killed_by = hurter_name
		Main.main.trigger_game_over.call_deferred()

func heal(value):
	var hevent:HealEvent = HealEvent.new(value)
	health = clamp(health + max(hevent.healed_amount,0),0,max_health)
	print("healed for %s" % hevent.healed_amount)
func knockback(vector:Vector2,power:float):
	if no_control: return
	kb_override = true
	kb_override_vector = vector * power
	velocity = kb_override_vector
func throw():
	if throwmode: return
	throwmode = true
	var item = Main.main.resources.get_selected_item()
	var throw_target = ThrowTarget.new(position - size/2,item)
	Main.main.current_level.add_child(throw_target)

func get_damage(base):
	return base * damage_mult
