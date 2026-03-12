extends Node2D

var string_array:Array[String]=[]
var started_cutscene = false
var allow_input = false
var inventory_result:Array
var inv_string_dict:Dictionary[String,Item.Value]
var item_ids_checked:Array[int]=[]
var start_and_stop_value_color:Array[int] = [0,0]

func _ready() -> void:
	inventory_result = Main.main.resources.inventory.duplicate().filter(func(item:Item): return item != null)
	for item:Item in inventory_result:
		if not item or item_ids_checked.has(item.item_id): continue
		item_ids_checked.append(item.item_id)
		inv_string_dict.get_or_add("%s x%d" % [item.item_name,
		inventory_result.filter(func(i:Item): return item.item_id == i.item_id).size()],item.value)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
	if not started_cutscene:
		cutscene()
		started_cutscene = true
	pass

func cutscene():
	string_array.append("successfully escaped")
	await get_tree().create_timer(1).timeout
	string_array.append("removing self from dungeon: ")
	await get_tree().create_timer(1).timeout
	await get_tree().create_timer(0.1 + randf_range(0.04,0.08)).timeout
	string_array[1]=("removing self from dungeon: %s%%" % (str(24 + randi()%5)))
	await get_tree().create_timer(0.2 + randf_range(0.04,0.08)).timeout
	string_array[1]=("removing self from dungeon: %s%%" % (str(47 + randi()%5)))
	await get_tree().create_timer(0.12 + randf_range(0.04,0.08)).timeout
	string_array[1]=("removing self from dungeon: %s%%" % (str(59 + randi()%5)))
	await get_tree().create_timer(0.1 + randf_range(0.04,0.08)).timeout
	string_array[1]=("removing self from dungeon: %s%%" % (str(75 + randi()%5)))
	await get_tree().create_timer(0.07 + randf_range(0.04,0.08)).timeout
	string_array[1]=("removing self from dungeon: %s%%" % (str(93 + randi()%5)))
	await get_tree().create_timer(0.1 + randf_range(0.04,0.08)).timeout
	string_array[1]=("removing self from dungeon: 99%")
	await get_tree().create_timer(1.2 + randf_range(0.04,0.08)).timeout
	string_array[1]=("removing self from dungeon: 100%")
	await get_tree().create_timer(0.05).timeout
	string_array.append("recovery successful")
	await get_tree().create_timer(0.05).timeout
	string_array.append("-------------------")
	await get_tree().create_timer(1).timeout
	string_array.append("items obtained:" if not inv_string_dict.is_empty() else "nothing obtained")
	start_and_stop_value_color[0] = string_array.size() - 1
	start_and_stop_value_color[1] = start_and_stop_value_color[0] + inv_string_dict.size() + 1
	await get_tree().create_timer(1).timeout
	if not inv_string_dict.is_empty():
		for item in inv_string_dict.keys():
			string_array.append(item)
			queue_redraw()
			await get_tree().create_timer(0.2).timeout
	else:
		string_array.append("the princess is disappointed")
	await get_tree().create_timer(1).timeout
	string_array.append("press [ENTER] to return")
	allow_input = true

func _input(event: InputEvent) -> void:
	if allow_input and event.is_action_pressed("accept"):
		Main.main._ready()
		queue_free()
		Main.escaped = false
		Main.game_over = false

func _draw() -> void:
	draw_rect(Rect2(0,0,320,180),Main.colors[0])
	if string_array.size() < 1: return
	for i in range(string_array.size()):
		Main.draw_text(
			self,
			string_array[i],
			Vector2(1,90 - (8 * (string_array.size()-i + 1))),
			Main.colors[int(inv_string_dict.get(string_array[i]))] if start_and_stop_value_color[0] < i and start_and_stop_value_color[1] > i else Main.colors[7])
