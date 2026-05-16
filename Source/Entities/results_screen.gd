extends Node2D

var string_array:Array[String]=[]
var started_cutscene = false
var allow_input = false
var inventory_result:Array
var inv_string_dict:Dictionary[String,Item.Value]
var start_and_stop_value_color:Array[int] = [0,0]

func _ready() -> void:
	inventory_result = Main.main.resources.inventory.duplicate().filter(func(item:Item): return item != null)
	for item:Item in inventory_result:
		if not item: continue
		
		inv_string_dict.get_or_add("%s x%d" % [item.get_proper_item_name(),
		inventory_result.filter(func(i:Item): return item.get_script() == i.get_script()).size()],item.value)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
	if not started_cutscene:
		cutscene()
		started_cutscene = true
	pass

func cutscene():
	string_array.append("ESCAPE_SUCCESS")
	var remove_self_text = Main.main_lang.get_dialog("GAME_OVER_REMOVING_SELF")
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
	string_array.append("-------------------")
	await get_tree().create_timer(1).timeout
	var items_ob_str = Main.main_lang.get_dialog("ITEMS_GOT")
	string_array.append("%s" % items_ob_str if not inv_string_dict.is_empty() else "¬BMain¬¬.¬6main¬¬.¬6resources¬¬.inventory.¬Dis_empty¬¬() returned ¬8true")
	start_and_stop_value_color[0] = string_array.size() - 1
	start_and_stop_value_color[1] = start_and_stop_value_color[0] + inv_string_dict.size() + 1
	await get_tree().create_timer(1).timeout
	if not inv_string_dict.is_empty():
		for item in inv_string_dict.keys():
			string_array.append(item)
			queue_redraw()
			await get_tree().create_timer(0.2).timeout
	else:
		await get_tree().create_timer(0.3).timeout
		string_array.append("")
		string_array.append("ESCAPE_COWARD")
		string_array.append("")
	await get_tree().create_timer(1).timeout
	string_array.append("GAME_OVER_C")
	allow_input = true

func _input(event: InputEvent) -> void:
	if allow_input and event.is_action_pressed("accept"):
		Main.main.load_level(LevelID.Above)
		queue_free()
		Main.main.reset_run()
		Main.escaped = false
		Main.game_over = false

func _draw() -> void:
	draw_rect(Rect2(0,0,320,180),Main.colors[0])
	if string_array.size() < 1: return
	for i in range(string_array.size()):
		Main.draw_text(
			self,
			string_array[i],
			Vector2(1,180 - (8 * (string_array.size()-i + 1))),
			Main.colors[int(inv_string_dict.get(string_array[i]))] if start_and_stop_value_color[0] < i and start_and_stop_value_color[1] > i else Main.colors[7])
