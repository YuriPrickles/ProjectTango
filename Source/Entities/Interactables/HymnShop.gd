extends Interactable
class_name HymnShop
func _init(pos) -> void:
	super._init(pos,Rect2(-40,8,40,8))
	var static_body:StaticBody2D = StaticBody2D.new()
	Utils.attach_collision_shape(static_body,Rect2(-40,6,40,4),on_touch_thing,null)
	add_child(static_body)
	y_sort_offset = 8
	touching = false
	spr_dict={
		136: Vector2(0,0),
		137: Vector2(1,0),
		138: Vector2(2,0),
		139: Vector2(3,0),
		140: Vector2(4,0),
		152: Vector2(0,1),
		153: Vector2(1,1),
		154: Vector2(2,1),
		155: Vector2(3,1),
		156: Vector2(4,1),
	}
	queue_redraw()

func _process(delta: float) -> void:
	super._process(delta)

func _input(event: InputEvent) -> void:
	if touching and event.is_action_pressed("accept") and not Main.main.loaded_fullscreen:
		var plr = Main.main.get_player()
		plr.no_control = true
		Main.main.change_fullscreen(SusansWagon.new())
func _draw() -> void:
	draw_from_dict(spr_dict,-offset/2,0)
	if touching:
		Main.draw_text(self, "SUSAN_HOVERTEXT", Vector2(0,-24),Main.colors[7],Main.colors[0],false,true)
