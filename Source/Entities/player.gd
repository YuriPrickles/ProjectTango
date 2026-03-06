extends Actor
class_name Player

const SPEED = 100.0
var direction:Vector2
var facing: Vector2
var spr_index = 0
var sneaking:bool = false
var running:bool = false
@onready var camera:Camera2D = $Camera2D

func _ready() -> void:
	width = 8
	height = 8
	pass
func _process(delta: float) -> void:
	queue_redraw()
	
func _physics_process(delta: float) -> void:
	#camera.rotation = get_angle_to(position + direction)
	camera.zoom = Vector2(1,1) if not Main.main.debugmode else Vector2(0.125,0.125)
	direction = Input.get_vector("left", "right","up","down")
	sneaking = Input.is_action_pressed("sneak")
	running = Input.is_action_pressed("run")
	sneaking = sneaking && !running
	if direction:
		facing = direction
		queue_redraw()
		velocity = direction * SPEED * (1.4 if running and not sneaking else (1.0 if not sneaking else 0.4))
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debugmode"):
		Main.main.debugmode = !Main.main.debugmode
		get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS if Main.main.debugmode else Window.CONTENT_SCALE_MODE_VIEWPORT
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
	if direction:
		spr_index = (1 if direction.x > 0 else 2) if direction.x != 0 else (3 if direction.y < 0 else 0)
	Main.main.spr(get_canvas_item(),size/-2,spr_index)
