class_name Transitioner
extends Node2D
var offset:Vector2 = Vector2(-320,0)
var size:Vector2 = Vector2(320,180)
var wiping:bool = false

func _ready() -> void:
	z_index = Main.Depths.Transitioner
	process_mode = Node.PROCESS_MODE_ALWAYS

func screen_wipe_in()->void:
	offset.x = -320
	wiping = true
	get_tree().paused = true
	for j in range(10):
		offset.x += 32
		await get_tree().create_timer(0.04).timeout
		queue_redraw()
func screen_wipe_out()->void:
	offset.x = 0
	wiping = true
	for j in range(10):
		offset.x += 32
		await get_tree().create_timer(0.04).timeout
		queue_redraw()
	wiping = false
	get_tree().paused = false
func _draw() -> void:
	draw_rect(Rect2(offset,size),Main.colors[0])
