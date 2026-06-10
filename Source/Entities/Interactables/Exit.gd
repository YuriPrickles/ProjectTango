class_name Exit
extends Interactable

var closed = false
var starting_to_close = false

var pointlight:PointLight2D = PointLight2D.new()

func _init(pos:Vector2) -> void:
	super._init(pos,Rect2(0,6,16,4))
	draw_offset = Vector2(-8,0)
	spr_dict={
		67: Vector2(0,0),
		68: Vector2(1,0)
	}
	pointlight.texture = preload("res://Graphics/Atlases/Misc/pointlight.png")
	pointlight.texture_scale = 0.3
	pointlight.energy = 0.1
	add_child(pointlight)
func _process(delta: float) -> void:
	pointlight.energy = 0.6
	pointlight.texture_scale = 0.1 + (sin(Engine.get_frames_drawn() * 0.05) * 0.01 )
func _input(event: InputEvent) -> void:
	if touching and event.is_action_pressed("accept") and not starting_to_close:
		Main.main.disc_manager.stop_cd_player()
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
		plr.no_control = false
		plr.no_draw = false
		starting_to_close = false
		closed = false
		#Main.main.save_level()
		Main.main.add_child(preload("res://Source/Entities/ResultsScreen.tscn").instantiate())
		Main.escaped = true
		Main.main.run_gui.queue_free()
		for ch in Main.main._2DLayer.get_children():
			Main.main._2DLayer.remove_child(ch)
func _draw() -> void:
	super()
	draw_from_dict(spr_dict,Vector2.ZERO,0 if not closed else 16)
	#draw_circle(Vector2.ZERO,2,Main.colors[9])
	if touching:
		Main.main.drawn_text_layer.request_draw_text(
			Main.DrawnTextLayer.TextRequest.new(
				"EXIT_HOVERTEXT",
				position + Vector2(0,-16),
				Main.colors[7],
				Main.colors[0],
				false,
				true)
			)
	else:
		Main.main.drawn_text_layer.queue_redraw()
