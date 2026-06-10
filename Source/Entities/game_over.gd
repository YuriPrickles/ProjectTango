extends Node2D

var string_array=[]
var started_cutscene = false
var allow_input = false
var detect_savescum = true

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	if not started_cutscene:
		cutscene()
		started_cutscene = true
	pass

func cutscene():
	var remove_self_text = Main.main_lang.get_dialog("GAME_OVER_REMOVING_SELF")
	string_array.append("GAME_OVER_A")
	await get_tree().create_timer(1).timeout
	string_array.append("%s " % remove_self_text)
	await get_tree().create_timer(1).timeout
	await get_tree().create_timer(0.1 + randf_range(0.04,0.08)).timeout
	string_array[1]=("%s %s%%" % [remove_self_text, (str(24 + randi()%5))])
	await get_tree().create_timer(0.2 + randf_range(0.04,0.08)).timeout
	string_array[1]=("%s %s%%" % [remove_self_text, (str(47 + randi()%5))])
	await get_tree().create_timer(0.12 + randf_range(0.04,0.08)).timeout
	string_array[1]=("%s %s%%" % [remove_self_text, (str(59 + randi()%5))])
	await get_tree().create_timer(0.1 + randf_range(0.04,0.08)).timeout
	string_array[1]=("%s %s%%" % [remove_self_text, (str(75 + randi()%5))])
	await get_tree().create_timer(0.07 + randf_range(0.04,0.08)).timeout
	string_array[1]=("%s %s%%" % [remove_self_text, (str(93 + randi()%5))])
	await get_tree().create_timer(0.1 + randf_range(0.04,0.08)).timeout
	string_array[1]=("%s 99%%" % remove_self_text)
	await get_tree().create_timer(1.2 + randf_range(0.04,0.08)).timeout
	string_array[1]=("%s 100%%" % remove_self_text)
	await get_tree().create_timer(0.05).timeout
	string_array.append("GAME_OVER_B")
	await get_tree().create_timer(0.05).timeout
	string_array.append("-------------------")
	await get_tree().create_timer(1).timeout
	var defeated_by = Main.main_lang.get_dialog("GAME_OVER_DEFEATED")
	string_array.append("%s %s" % [defeated_by,Main.main.killed_by])
	await get_tree().create_timer(1).timeout
	string_array.append("GAME_OVER_C")
	allow_input = true



func _input(event: InputEvent) -> void:
	if allow_input and event.is_action_pressed("accept"):
		queue_free()
		Main.main.reset_run(true)
		Main.main.load_level(LevelID.Above)
		Main.game_over = false
		Main.escaped = false
		detect_savescum = false
		Main.main.terminal.save_game()

func _draw() -> void:
	draw_rect(Rect2(0,0,320,180),Main.colors[0])
	if string_array.size() < 1: return
	for i in range(string_array.size()):
		Main.draw_text(self,string_array[i],Vector2(1,180 - (8 * (string_array.size()-i + 1))))
