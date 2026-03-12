class_name Exit
extends Entity

var touching = false
var closed = false
var starting_to_close = false

var spr_dict:Dictionary[int, Vector2]={
	67: Vector2(0,0),
	68: Vector2(1,0)
}

func _init(pos:Vector2) -> void:
	super._init(pos,Rect2(-16,-2,16,4))

func on_touch_player(body):
	if body is Player:
		touching = true
		queue_redraw()
func on_untouch_player(body):
	if body is Player:
		touching = false
		queue_redraw()

func _input(event: InputEvent) -> void:
	if touching and event.is_action_pressed("accept") and not starting_to_close:
		starting_to_close = true
		var plr:Player = Main.main.get_player()
		plr.position = position + Vector2(0,0)
		plr.facing = Vector2.DOWN
		plr.direction = Vector2.DOWN
		plr.queue_redraw()
		plr.no_control = true
		await get_tree().create_timer(1).timeout
		plr.no_draw = true
		plr.queue_redraw()
		closed = true
		queue_redraw()
		await get_tree().create_timer(1).timeout
		Main.main.add_child(preload("res://Source/Entities/ResultsScreen.tscn").instantiate())
		Main.escaped = true
		Main.main.run_gui.queue_free()
		for ch in Main.main._2DLayer.get_children():
			Main.main._2DLayer.remove_child(ch)
func _draw() -> void:
	draw_from_dict(spr_dict,offset/-2,0 if not closed else 16)
	#draw_circle(Vector2.ZERO,2,Main.colors[9])
	if touching:
		Main.draw_text_centered(self, "[enter] to exit", Vector2(0,-16),Main.colors[7])
