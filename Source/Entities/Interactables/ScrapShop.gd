extends Interactable
class_name ScrapShop
func _init(pos) -> void:
	super._init(pos,Rect2(-24,8,24,8))
	var static_body:StaticBody2D = StaticBody2D.new()
	Utils.attach_collision_shape(static_body,Rect2(-24,6,24,4),on_touch_thing,null)
	add_child(static_body)
	y_sort_offset = 8
	touching = false
	spr_dict={
		104: Vector2(0,0),
		105: Vector2(1,0),
		106: Vector2(2,0),
		120: Vector2(0,1),
		121: Vector2(1,1),
		122: Vector2(2,1),
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
	draw_from_dict(spr_dict,-offset/2,0)
	if touching:
		Main.draw_text_centered(self, "[enter]\nenter scrapnest", Vector2(0,-24),Main.colors[7],Main.colors[0])
		Main.draw_text_centered(self, "sell scraps!", Vector2(0,-12),Main.colors[5],Main.colors[0])
