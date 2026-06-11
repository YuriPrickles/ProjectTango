extends Level
class_name OvergrownHalls


func _ready() -> void:
	id = LevelID.Floor1
	dungeon_layout = preload("res://Source/Entities/ProceduralGeneration/Levels/1-OvergrownHalls/Floor1Splitter.tscn").instantiate()
	add_child(dungeon_layout)
	dungeon_layout.walls = walls
	dungeon_layout.floor = floor
	pass # Replace with function body.


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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	queue_redraw()
	if !spawned:
		artifact_positions.append(dungeon_layout.artifact_rooms[0].get_center() * dungeon_layout.tile_size)
		player = spawn_player()
		spawn_enemies()
		spawn_objects()
		spawn_treasures()
		print("Rooms: %s" % dungeon_layout.rooms.size())
		print("Pathways: %s" % dungeon_layout.paths.size())
		print("Scrap: %s" % items.get_child_count())
		spawned = true
		#move_child(player,items.get_index())

func spawn_enemies():
	for room:Branch in dungeon_layout.rooms:
		if dungeon_layout.rooms.find(room) < 15: continue
		var base_snitchweed_chance = 20
		var base_snail_chance = 15
		var base_gasberry_chance = 50
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
		if randi_range(0,100) <= base_gasberry_chance:
			if room.size.x < 6 and room.size.y < 5: continue
			var spawn_offset = Vector2i(randi_range(-2,2),randi_range(-2,2))
			var final_spawn = (room.get_center())
			enemies.add_child(Gasberry.new((final_spawn + spawn_offset) * 8,dungeon_layout.rooms.find(room)))

func spawn_scrap(amount:int) -> void:
	for i in range(amount):
		var room:Branch = dungeon_layout.rooms.pick_random()
		var randpos = (room.get_center() + Vector2i(randi_range(-room.size.x,room.size.x),randi_range(-room.size.y,room.size.y)) / 2) * dungeon_layout.tile_size
		if not Splitter.is_inside_padding(randpos.x,randpos.y,room,padding):
			return
		match randi_range(0,2):
			0:
				items.add_child.call_deferred(Pickup.new(Metal, randpos))
			1:
				items.add_child.call_deferred(Pickup.new(Wires, randpos))
			2:
				items.add_child.call_deferred(Pickup.new(Battery, randpos))



func spawn_objects() -> void:
	var tree_chance = 100
	var polygon:PackedVector2Array = [
		Vector2(0,0) * dungeon_layout.tile_size,
		Vector2(dungeon_layout.floor_size.x,0) * dungeon_layout.tile_size,
		dungeon_layout.floor_size * dungeon_layout.tile_size,
		Vector2(0,dungeon_layout.floor_size.y) * dungeon_layout.tile_size]
	var points = PoissonDiscSampling.generate_points_for_polygon(polygon, 16, 5)
	for pos in points:
		if not dungeon_layout.paths.any(
			func(path):
				for i in range(path['right'].x - path['left'].x):
					var tilepos = Vector2i(path['left'].x+i,path['left'].y)
					if pos.distance_to(tilepos * dungeon_layout.tile_size) <= 20:
						return true
				for i in range(path['right'].y - path['left'].y):
					var tilepos = Vector2i(path['left'].x,path['left'].y+i)
					if pos.distance_to(tilepos * dungeon_layout.tile_size) <= 20:
						return true
				return false
				):
			var newpos = Vector2(pos.x - int(pos.x) % dungeon_layout.tile_size,pos.y - int(pos.y) % dungeon_layout.tile_size)
			other_things.add_child(TreeDecor.new(newpos))
	return


class TreeDecor:
	extends DecorObject
	var top_sprites:Array[int] = [6,7,8,9,135]
	var trunks:Array[Vector2]
	var tree_height:int
	var chosen_spr:int = top_sprites.pick_random()
	func _init(pos) -> void:
		tree_height = randi_range(0,3)
		super(pos, Rect2(0,3,4,3))
		spr_dict[chosen_spr] = Vector2(0,-1 - tree_height)
		if tree_height > 0: for i in range(tree_height + 1): trunks.append(Vector2(0,-i))
		spr_dict[chosen_spr + 16] = Vector2(0,0)
		add_child(TreeTrunk.new(self))
		add_child(TreeLeaves.new(self))
		queue_redraw()
	var opacity:float
	func _process(delta: float) -> void:
		var plr:Player = Main.main.get_player()
		if plr.position.distance_to(position) > 200: return
		super(delta)
		opacity = min(100 ,max(3,60 + (plr.position.distance_to(position)) - 80)) * 0.01
	class TreeTrunk:
		extends Node2D
		var tree_base:TreeDecor
		func _init(tree:TreeDecor):
			tree_base = tree
		func _process(delta: float) -> void:
			var plr:Player = Main.main.get_player()
			if plr.position.distance_to(tree_base.position) <= 200:
				if Engine.get_frames_drawn() % 18 == 0:
					queue_redraw()
					modulate.a = tree_base.opacity * 15
			else: return
		func _draw() -> void:
			for index in tree_base.spr_dict.keys():
				if tree_base.top_sprites.has(index):
					Main.spr(Main.GameAtlas,self,(tree_base.draw_offset) + (tree_base.spr_dict.get(index)) * (Main.SPR_SIZE),index,Main.colors[7])
			for t in tree_base.trunks:
				Main.spr(Main.GameAtlas,self,t * Main.SPR_SIZE + tree_base.draw_offset,19, Main.colors[7])
			
	class TreeLeaves:
		extends Node2D
		var tree_base:TreeDecor
		func _init(tree:TreeDecor):
			tree_base = tree
		func _process(delta: float) -> void:#
			var plr:Player = Main.main.get_player()
			if tree_base.position.distance_to(plr.position) <= 200:
				if Engine.get_frames_drawn() % 18 == 0:
					queue_redraw()
					modulate.a = tree_base.opacity
		func _draw() -> void:
			for j in range(3):
				for i in range(5):
					if i - j <= 0: continue
					draw_rect(
						Rect2(tree_base.spr_dict.get(tree_base.chosen_spr) * Main.SPR_SIZE + tree_base.draw_offset + Vector2(randi_range(-i,i),i),
						Vector2(1 + ((i-j)*3),2 + (i-j) * 2)),
						Main.colors[9])
					draw_rect(
						Rect2(tree_base.spr_dict.get(tree_base.chosen_spr) * Main.SPR_SIZE + tree_base.draw_offset + Vector2(randi_range(-i,i), i + j),
						Vector2(1 + (i*2),2 + i * 1)),
						Main.colors[10])
			for j in range(2):
				for i in range(4):
					if i - j <= 0: continue
					draw_rect(
						Rect2(tree_base.spr_dict.get(tree_base.chosen_spr) * Main.SPR_SIZE + tree_base.offset + Vector2(randi_range(-i,i), i + j),
						Vector2(1 + (i*2),2 + i * 1)),
						Main.colors[10])
	func _draw():
		for index in spr_dict.keys():
			if not top_sprites.has(index):
				Main.spr(Main.GameAtlas,self,(draw_offset) + (spr_dict.get(index)) * (Main.SPR_SIZE),index,Main.colors[7])
		

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
