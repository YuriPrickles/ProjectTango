extends Splitter
class_name Floor2Splitter

func _ready():
	tile_size = 8
	floor_size = Vector2i(200, 100)
	splitiness = 5
	root_node  = Branch.new(Vector2i(0, 0), floor_size)
	root_node.split(splitiness, paths)
	rooms = root_node.get_leaves()
	padding = Vector4i(2,2,3,3)
	var artifact_room_index = randi_range((int)((pow(2,splitiness + 1)) * 0.75),pow(2,splitiness + 1)) - 1
	artifact_rooms.append(rooms[min(artifact_room_index, rooms.size()-1)])
	queue_redraw()

static func is_inside_padding(x, y, leaf:Branch, pad):
	return (Vector2i(x,y)).distance_to(leaf.size / 2) > (leaf.size / 2).length() * 0.8

func _draw():
	if Main.main.debugmode:
		for leaf in root_node.get_leaves():
			draw_rect(
				Rect2(
					leaf.position.x * tile_size, # x
					leaf.position.y * tile_size, # y
					leaf.size.x * tile_size, # width
					leaf.size.y * tile_size # height
				), 
				Color.GREEN if not artifact_rooms.has(leaf) else Color.YELLOW, # colour
				false # is filled
			)
	if walls == null: return
	for leaf in root_node.get_leaves():
		for x in range(leaf.size.x):
			for y in range(leaf.size.y):
				var tilepos = Vector2i(x + leaf.position.x,y + leaf.position.y)
				if is_inside_padding(x,y, leaf, padding):
					solid_cells.append(tilepos)
					for j in [3,2,1,-1,-2,-3]:
						for k in [3,2,1,-1,-2,-3]:
							var extr_tile = Vector2i(j, k)
							if randi() % 10 < 3:
								solid_cells.append(tilepos + extr_tile)
								walls.set_cell(tilepos + extr_tile, 1, Vector2i(0, 5))
					walls.set_cell(tilepos, 1, Vector2i(0, 5))
				else:
					if not floor.get_cell_tile_data(tilepos * 8):
						floor.set_cell(tilepos, 1, get_floor_tile(Vector2i(1, 15)))
	for path in paths:
		var tile:Vector2 = Vector2i(1, 15)
		if guaranteed_paths.size() > 2:
			tile = Vector2(1, 9)
		for i in range(path['right'].x - path['left'].x):
			var tilepos = Vector2i(path['left'].x+i,path['left'].y)
			walls.erase_cell(tilepos)
			floor.set_cell(tilepos, 1, tile)
			if Utils.maybe() :
				for j in [1,0,-1]:
					for k in [1,0,-1]:
						var extr_tile = Vector2i(j,k)
						for r in range(solid_cells.count(tilepos + extr_tile)):
							solid_cells.erase(tilepos + extr_tile)
						walls.erase_cell(tilepos + extr_tile)
						floor.set_cell(tilepos + extr_tile, 1, tile)
		for i in range(path['right'].y - path['left'].y):
			var tilepos = Vector2i(path['left'].x,path['left'].y+i)
			solid_cells.erase(tilepos)
			walls.erase_cell(tilepos)
			floor.set_cell(tilepos, 1, tile)
			for r in range(solid_cells.count(tilepos)):
				solid_cells.erase(tilepos)
			if Utils.maybe():
				for j in [1,0,-1]:
					for k in [1,0,-1]:
						var extr_tile = Vector2i(j,k)
						for r in range(solid_cells.count(tilepos + extr_tile)):
							solid_cells.erase(tilepos + extr_tile)
						walls.erase_cell(tilepos + extr_tile)
						floor.set_cell(tilepos + extr_tile, 1, tile)
	for x in range(-1, floor_size.x + 1):
		for y in range(-1, floor_size.y + 1):
			if (x < 0 or x > floor_size.x - 1) or (y < 0 or y > floor_size.y - 1):
				solid_cells.append(Vector2i(x,y))
				walls.set_cell(Vector2i(x,y), 1, Vector2i(2,2))
	walls.set_cells_terrain_connect(solid_cells,0,1)
	walls.set_cells_terrain_connect(solid_cells,0,1)
	walls.set_cells_terrain_connect(solid_cells,0,1)

pass
		
