extends Interactable
class_name ScrapShop
func _init(pos) -> void:
	super._init(pos,Rect2(0,12,24,8))
	var static_body:StaticBody2D = StaticBody2D.new()
	Utils.attach_collision_shape(static_body,Rect2(0,6,24,4),on_touch_thing,null)
	add_child(static_body)
	touching = false
	draw_offset = Vector2(-12,0)
	spr_dict={
		106: Vector2(0,-1),
		107: Vector2(1,-1),
		108: Vector2(2,-1),
		122: Vector2(0,0),
		123: Vector2(1,0),
		124: Vector2(2,0),
	}
	queue_redraw()

func _process(delta: float) -> void:
	super._process(delta)

func _input(event: InputEvent) -> void:
	if touching and event.is_action_pressed("accept") and not Main.main.loaded_fullscreen:
		var plr = Main.main.get_player()
		plr.no_control = true
		Main.main.change_fullscreen(Scrapnest.new())
func _draw() -> void:
	super()
	draw_from_dict(spr_dict,Vector2.ZERO,0)
	if touching:
		Main.draw_text(self, "SCRAPNEST_HOVERTEXT", Vector2(0,-24),Main.colors[7],Main.colors[0],false,true)
