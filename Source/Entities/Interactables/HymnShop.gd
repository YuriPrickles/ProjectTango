extends Interactable
class_name HymnShop
func _init(pos) -> void:
	super._init(pos,Rect2(0,12,40,8))
	var static_body:StaticBody2D = StaticBody2D.new()
	Utils.attach_collision_shape(static_body,Rect2(0,6,40,4),on_touch_thing,null)
	add_child(static_body)
	touching = false
	draw_offset = Vector2(-20,0)
	spr_dict={
		136: Vector2(0,-1),
		137: Vector2(1,-1),
		138: Vector2(2,-1),
		139: Vector2(3,-1),
		140: Vector2(4,-1),
		152: Vector2(0,0),
		153: Vector2(1,0),
		154: Vector2(2,0),
		155: Vector2(3,0),
		156: Vector2(4,0),
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
	super()
	draw_from_dict(spr_dict,Vector2.ZERO,0)
	if touching:
		Main.draw_text(self, "SUSAN_HOVERTEXT", Vector2(0,-24) - draw_offset,Main.colors[7],Main.colors[0],false,true)
