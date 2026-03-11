extends Node2D

var string_array=[]
var started_cutscene = false

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
	string_array.append("game over")
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
	string_array.append("destroyed by an enemy")
	await get_tree().create_timer(1).timeout
	string_array.append("press any key to return")

func _draw() -> void:
	draw_rect(Rect2(0,0,320,180),Main.colors[0])
	if string_array.size() < 1: return
	for i in range(string_array.size()):
		Main.draw_text(self,string_array[i],Vector2(1,90 - (8 * (string_array.size()-i + 1))))
