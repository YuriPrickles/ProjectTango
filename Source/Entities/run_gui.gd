class_name RunGUI
extends CanvasLayer

var resources:ResourceManager
@onready var gui_drawificator:Node2D = $GUIDrawificator
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resources = Main.main.resources
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Main.game_finished:
		gui_drawificator.queue_redraw()
	pass
