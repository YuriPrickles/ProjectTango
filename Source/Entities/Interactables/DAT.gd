extends Interactable
class_name DAT
func _init(pos) -> void:
	super._init(pos,Rect2(0,12,24,8))
	var static_body:StaticBody2D = StaticBody2D.new()
	Utils.attach_collision_shape(static_body,Rect2(0,6,24,4),on_touch_thing,null)
	add_child(static_body)
	draw_offset = Vector2(-12,0)
	touching = false
	spr_dict={
		141: Vector2(0,-1),
		142: Vector2(1,-1),
		143: Vector2(2,-1),
		157: Vector2(0,0),
		158: Vector2(1,0),
		159: Vector2(2,0),
	}
	queue_redraw()

func _process(delta: float) -> void:
	super._process(delta)

func _input(event: InputEvent) -> void:
	if touching and event.is_action_pressed("accept") and not Main.main.loaded_fullscreen:
		Main.main.terminal.special_commands = true
		Main.main.toggle_terminal()
		Main.main.terminal.help("dat")
		
func _draw() -> void:
	super()
	draw_from_dict(spr_dict,Vector2.ZERO,0)
	if touching:
		Main.draw_text(self, "COMPUTER_HOVERTEXT", Vector2(0,-24),Main.colors[7],Main.colors[0],false,true)
