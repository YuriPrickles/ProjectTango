extends Actor
class_name Player

const SPEED = 65.0
var direction:Vector2
var facing: Vector2
var spr_index = 0
var sneaking:bool = false
var running:bool = false
var health:int=10
var max_health:int = 10
const IFRAMES = 0.2
var iframe_timer:float = 0
var kb_override = false
var kb_override_vector:Vector2
var no_control = false
var no_draw = false
@onready var camera:Camera2D = $Camera2D

func _ready() -> void:
	z_index = Main.Depths.Player
	kb_override = false
	width = 8
	height = 8
	pass
func _process(delta: float) -> void:
	if iframe_timer > 0:
		iframe_timer = clampf(iframe_timer - delta,0,IFRAMES)
	if no_draw: return
	queue_redraw()
	
func _physics_process(delta: float) -> void:
	#camera.rotation = get_angle_to(position + direction)
	camera.zoom = Vector2(1,1) if not Main.main.debugmode else Vector2(0.125,0.125)
	direction = Input.get_vector("left", "right", "up", "down")
	sneaking = Input.is_action_pressed("sneak")
	running = Input.is_action_pressed("run")
	sneaking = sneaking && !running
	if kb_override_vector.length() <= 0:
		if direction:
			facing = direction
			if no_draw: return
			queue_redraw()
			velocity = direction * SPEED * (1.4 if running and not sneaking else (1.0 if not sneaking else 0.4))
		else:
			velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	else:
		kb_override_vector = kb_override_vector.move_toward(Vector2.ZERO, SPEED * .25)
		velocity = kb_override_vector
		if kb_override_vector.length() <= 0:
			kb_override_vector = Vector2.ZERO
			kb_override = false
	if no_control:
		velocity = Vector2.ZERO
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debugmode"):
		Main.main.debugmode = !Main.main.debugmode
		get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS if Main.main.debugmode else Window.CONTENT_SCALE_MODE_VIEWPORT
	if no_control:
		return
	if event.is_action_pressed("inventory"):
		Main.main.inventory_open = not Main.main.inventory_open
		pass
	if Main.main.inventory_open:
		if event.is_action_pressed("throw") and Main.main.resources.get_selected_item():
			var item = Main.main.resources.get_selected_item()
			var pickup = Pickup.new(item.item_id,position,false,true)
			Main.main.current_level.items.add_child(pickup)
			Main.main.resources.remove_inv_item()
			return
		if event.is_action_pressed("inv_left") or event.is_action_pressed("inv_right"):
			var input = Input.get_axis("inv_left","inv_right")
			if Main.main.resources.inv_selected + int(input) <= -1 and input == -1:
				Main.main.resources.inv_selected = 14
			else: Main.main.resources.inv_selected += int(input)
		if event.is_action_pressed("inv_up") or event.is_action_pressed("inv_down"):
			var input = Input.get_axis("inv_up","inv_down")
			if Main.main.resources.inv_selected + int(input) * 5 <= -1 and input == -1:
				Main.main.resources.inv_selected += 10
			else: Main.main.resources.inv_selected += int(input) * 5

func _draw() -> void:
	#Main.main.draw_text_centered(self,"hi pearlings", (Vector2(0,-32)))
	#Main.main.draw_text_centered(self,"centered text", (Vector2(0,-24)))
	#Main.main.draw_text(self,"uncentered text", (Vector2(0,-16)))
	if no_draw: return
	if facing:
		spr_index = (1 if facing.x > 0 else 2) if facing.x != 0 else (3 if facing.y < 0 else 0)
	if floori(iframe_timer * 100.0) % 4 == 0 and iframe_timer < IFRAMES:
		Main.spr(Main.GameAtlas,self,size/-2,spr_index)

func hurt(value, hurter:Entity):
	if iframe_timer > 0 or no_control: return
	iframe_timer = IFRAMES
	health -= value
	if health <= 0:
		Main.main.killed_by = hurter.dmg_source_name
		Main.main.trigger_game_over.call_deferred()
func knockback(vector:Vector2,power:float):
	kb_override = true
	kb_override_vector = vector * power
	velocity = kb_override_vector
