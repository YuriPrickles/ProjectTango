class_name Exit
extends Entity

var touching = false

var spr_dict:Dictionary[int, Vector2]={
	67: Vector2(0,0),
	68: Vector2(1,0)
}

func _init(pos:Vector2) -> void:
	super._init(pos,Rect2(0,4,16,4))

func on_touch_player(body):
	if body is Player:
		touching = true
		queue_redraw()
func on_untouch_player(body):
	if body is Player:
		touching = false
		queue_redraw()

func _input(event: InputEvent) -> void:
	if touching and event.is_action_pressed("accept"):
		Main.main.add_child(preload("res://Source/Entities/ResultsScreen.tscn").instantiate())
		Main.escaped = true
		Main.main.run_gui.gui_drawificator.queue_redraw()
		for ch in Main.main._2DLayer.get_children():
			Main.main._2DLayer.remove_child(ch)
func _draw() -> void:
	draw_from_dict(spr_dict,offset/2,0)
	if touching:
		Main.draw_text_centered(self, "[enter] to exit", Vector2(16,-3),Main.colors[7])
