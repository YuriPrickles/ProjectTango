class_name Git
extends Node2D

var main_rect:Rect2 = Rect2(0,0,320,180)
var texture:Texture2D = preload("res://Graphics/Fullscreens/git.png")
var fade_opacity:float = 1
func _ready() -> void:
	z_index = Main.Depths.Fullscreens
	for i in range(10):
		await get_tree().create_timer(0.8).timeout
		fade_opacity -= 0.1
		queue_redraw()
	var key:String = str(Main.main.options.savescum_amount) if Main.main.options.savescum_amount <= 3 else "ONWARDS"
	await Main.main.say("GIT_SAVESCUM_%s" % key,Vector2(8,152),Vector2(24,4))
	for i in range(10):
		await get_tree().create_timer(0.3).timeout
		fade_opacity += 0.1
		queue_redraw()
	await get_tree().create_timer(1.2).timeout
	Main.main.remove_fullscreen(false)
	Main.main.get_player().no_control = false

func _draw() -> void:
	texture.draw_rect_region(get_canvas_item(),main_rect,main_rect)
	draw_rect(Rect2(Vector2(0,0),Vector2(320,180)),Main.colors[0] * fade_opacity)
