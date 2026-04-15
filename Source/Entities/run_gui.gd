class_name RunGUI
extends CanvasLayer

var resources:ResourceManager
@onready var gui_drawificator:GUIDrawificator = $GUIDrawificator
static var draw_me = false

func _ready() -> void:
	resources = Main.main.resources

func _process(delta: float) -> void:
	if not Main.game_finished:
		gui_drawificator.queue_redraw()
	pass
