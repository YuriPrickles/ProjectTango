extends Node2D
class_name Level
@onready var items = $Items
@onready var enemies: Node2D = $Enemies
@onready var traps: Node2D = $Traps
@onready var other_things: Node2D = $OtherThings

enum TilemapLayers{
	Floor,
	Walls,
	Things
}
var tilemap:TileMapLayer
var dungeon_layout:Splitter = preload("res://Source/Entities/ProceduralGeneration/Splitter.tscn").instantiate()
var player:Player
var artifact_positions:Array[Vector2]

func _ready() -> void:
	tilemap = get_node("TileMapLayer")
	add_child(dungeon_layout)
	dungeon_layout.tilemap = tilemap
	pass # Replace with function body.


func spawn_player():
	var plr:Player = preload("res://Source/Entities/player.tscn").instantiate()
	var player_pos:Vector2i = dungeon_layout.rooms[0].get_center() * 8
	var exit_pos:Vector2i
	for room:Branch in dungeon_layout.rooms:
		if room.size.x > 7 and room.size.y > 6:
			player_pos = room.get_center() * 8
			var exit_room:Branch = dungeon_layout.rooms[dungeon_layout.rooms.find(room) + 1]
			if exit_room.size.x > 7 and exit_room.size.y > 6:
				for rm in dungeon_layout.rooms:
					if rm.size.x > 7 and rm.size.y > 6 and rm != room:
						exit_room = room
						break
			exit_pos = exit_room.get_center() * 8
			print(room.size)
			break
	plr.position = player_pos
	other_things.add_child(Exit.new(exit_pos ))
	add_child(plr)
	return plr

var spawned = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	if !spawned:
		artifact_positions.append(dungeon_layout.artifact_rooms[0].get_center() * 8)
		player = spawn_player()
		spawn_scrap()
		spawn_enemies()
		spawn_treasures()
		print("Rooms: %s" % dungeon_layout.rooms.size())
		print("Pathways: %s" % dungeon_layout.paths.size())
		print("Scrap: %s" % items.get_child_count())
		spawned = true

func spawn_enemies():
	for room:Branch in dungeon_layout.rooms:
		if dungeon_layout.rooms.find(room) < 15: continue
		var base_snitchweed_chance = 20
		var base_snail_chance = 15
		var initial_pos = room.get_center()+ Vector2i(randi_range(-room.size.x,room.size.x),randi_range(-room.size.y,room.size.y)) / 2

		if randi_range(0,100) <= base_snitchweed_chance:
			for i in range(randi_range(4,6)):
				var direction_array=[1,-1,0]
				#for k in range(randi_range(1,3)):
				for j in range(0,2):
					var shuffled_dir=direction_array.duplicate()
					shuffled_dir.shuffle()
					var randpos = (initial_pos + Vector2i(shuffled_dir[j],shuffled_dir[(j + randi_range(0,2))%3]) * i) * dungeon_layout.tile_size
					for t:Trap in traps.get_children():
						if t is Snitchweed and t.int_position == randpos:
							continue
					if dungeon_layout.solid_cells.has(randpos / dungeon_layout.tile_size):
						continue
					traps.add_child(Snitchweed.new(randpos))
		if randi_range(0,100) <= base_snail_chance:
			var spawn_offset = Vector2i(0,0)
			while dungeon_layout.solid_cells.has((initial_pos + spawn_offset) / dungeon_layout.tile_size):
				spawn_offset += Vector2i(1,1)
			enemies.add_child(Gastropoke.new((initial_pos + spawn_offset)* dungeon_layout.tile_size))
func spawn_scrap():
	for room:Branch in dungeon_layout.rooms:
		var base_scrap_chance = 5
		for i in range(4):
			if randi_range(0,100) <= base_scrap_chance:
				base_scrap_chance += 15
				var randpos = (room.get_center() + Vector2i(randi_range(-room.size.x,room.size.x),randi_range(-room.size.y,room.size.y)) / 2) * dungeon_layout.tile_size
				if not Splitter.is_inside_padding(randpos.x,randpos.y,room,Splitter.padding):
					continue
				match randi_range(0,2):
					0:
						items.add_child(Pickup.new(ItemID.Metal, randpos))
					1:
						items.add_child(Pickup.new(ItemID.Wires, randpos))
					2:
						items.add_child(Pickup.new(ItemID.Battery, randpos))
func spawn_treasures():
	for room:Branch in dungeon_layout.artifact_rooms:
		items.add_child(Pickup.new(ItemID.GoldenToad, room.get_center() * dungeon_layout.tile_size))
	

func get_compass_vector():
	return player.position.direction_to(artifact_positions[0]) * 5

##Eventually, this is where the level layers are drawn.[br]
##Each level layer will have will have its own drunction (draw function) so that the order can be rearranged easily.
func _draw():
	#for room:Branch in dungeon_layout.rooms:
		#Main.main.draw_text(dungeon_layout,str(dungeon_layout.rooms.find(room)),room.get_center() * 8)
	draw_rect(Rect2(
		position - Vector2(dungeon_layout.floor_size * dungeon_layout.floor_size),
		(dungeon_layout.floor_size * dungeon_layout.floor_size* dungeon_layout.floor_size* dungeon_layout.floor_size) ),
		Color.BLACK,true)
