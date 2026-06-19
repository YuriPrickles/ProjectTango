extends Level
class_name DoomedDesert


func _ready() -> void:
	id = LevelID.Floor2
	dungeon_layout = preload("res://Source/Entities/ProceduralGeneration/Levels/2-DoomedDesert/Floor2Splitter.tscn").instantiate()
	add_child(dungeon_layout)
	dungeon_layout.walls = walls
	dungeon_layout.floor = floor


func spawn_player():
	var plr:Player = preload("res://Source/Entities/player.tscn").instantiate()
	var player_pos:Vector2i = dungeon_layout.rooms[0].get_center() * 8
	var exit_pos:Vector2i
	var dat_pos:Vector2i
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
			break
	var later_rooms:Array[Branch]
	for i in range(dungeon_layout.rooms.size()):
		if i >= dungeon_layout.rooms.size() / 2:
			later_rooms.append(dungeon_layout.rooms[i])
	var dat_room:Branch = later_rooms.pick_random()
	var retries = 200
	while retries > 0 and (dat_room.size.x <= 10 or dat_room.size.y <= 10):
		dat_room = later_rooms.pick_random()
		retries -= 1
	dat_pos = dat_room.get_center() * 8
	terminal_pos = dat_pos
	plr.position = player_pos
	other_things.add_child(Exit.new(exit_pos))
	#other_things.add_child(DAT.new(dat_pos))
	add_child(plr)
	spawn_scrap(4)
	setup_finished.emit()
	return plr

func _process(delta: float) -> void:
	super._process(delta)
	queue_redraw()
	if !spawned:
		artifact_positions.append(dungeon_layout.artifact_rooms[0].get_center() * dungeon_layout.tile_size)
		player = spawn_player()
		spawn_enemies()
		spawn_objects()
		spawn_treasures()
		spawned = true

func spawn_enemies(): pass
func spawn_scrap(amount:int) -> void:
	for i in range(amount):
		var room:Branch = dungeon_layout.rooms.pick_random()
		var randpos = (room.get_center() + Vector2i(randi_range(-room.size.x,room.size.x),randi_range(-room.size.y,room.size.y)) / 2) * dungeon_layout.tile_size
		while not Splitter.is_inside_padding(randpos.x,randpos.y,room,padding):
			randpos = (room.get_center() + Vector2i(randi_range(-room.size.x,room.size.x),randi_range(-room.size.y,room.size.y)) / 2) * dungeon_layout.tile_size
		match randi_range(0,2):
			0:
				items.add_child.call_deferred(Pickup.new(Metal, randpos))
			1:
				items.add_child.call_deferred(Pickup.new(Wires, randpos))
			2:
				items.add_child.call_deferred(Pickup.new(Battery, randpos))



func spawn_objects() -> void:
	var polygon:PackedVector2Array = [
		Vector2(0,0) * dungeon_layout.tile_size,
		Vector2(dungeon_layout.floor_size.x,0) * dungeon_layout.tile_size,
		dungeon_layout.floor_size * dungeon_layout.tile_size,
		Vector2(0,dungeon_layout.floor_size.y) * dungeon_layout.tile_size]
	return

func spawn_treasures():
	for room:Branch in dungeon_layout.artifact_rooms:
		items.add_child(Pickup.new(Item.artifacts_floor1.pick_random(), room.get_center() * dungeon_layout.tile_size))
	

func get_compass_vector():
	return player.position.direction_to(artifact_positions[0]) * 5

func _draw():
	#for room:Branch in dungeon_layout.rooms:
		#Main.main.draw_text(dungeon_layout,str(dungeon_layout.rooms.find(room)),room.get_center() * 8)
	draw_rect(Rect2(
		position - Vector2(dungeon_layout.floor_size * dungeon_layout.floor_size),
		(dungeon_layout.floor_size * dungeon_layout.floor_size* dungeon_layout.floor_size* dungeon_layout.floor_size) ),
		Color.BLACK,true)
