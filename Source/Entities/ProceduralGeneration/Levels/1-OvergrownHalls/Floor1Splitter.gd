extends Splitter
class_name Floor1Splitter

func _ready():
	tile_size = 8
	floor_size = Vector2i(120, 80)
	splitiness = 6
	root_node  = Branch.new(Vector2i(0, 0), floor_size)
	root_node.split(splitiness, paths)
	rooms = root_node.get_leaves()
	var artifact_room_index = randi_range((int)((pow(2,splitiness + 1)) * 0.75),pow(2,splitiness + 1)) - 1
	artifact_rooms.append(rooms[min(artifact_room_index, rooms.size()-1)])
	queue_redraw()

static func is_inside_padding(x, y, leaf, pad):
	return x <= pad.x or y <= pad.y or x >= leaf.size.x - pad.z or y >= leaf.size.y - pad.w


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
				floor.set_cell(tilepos, 1, get_floor_tile(Vector2i(1, 7)))
				if is_inside_padding(x,y, leaf, padding):
					solid_cells.append(tilepos)
					walls.set_cell(tilepos, 1, Vector2i(0, 5))
	for path in paths:
		var tile:Vector2 = Vector2i(1, 7)
		if guaranteed_paths.size() > 2:
			tile = Vector2(1, 9)
		for i in range(path['right'].x - path['left'].x):
			solid_cells.erase(path['left']+Vector2i(i,0))
			walls.set_cell(Vector2i(path['left'].x+i,path['left'].y), 1, tile)
		for i in range(path['right'].y - path['left'].y):
			solid_cells.erase(path['left']+Vector2i(0,i))
			walls.set_cell(Vector2i(path['left'].x,path['left'].y+i), 1, tile)
	for x in range(-1, floor_size.x + 1):
		for y in range(-1, floor_size.y + 1):
			if (x < 0 or x > floor_size.x - 1) or (y < 0 or y > floor_size.y - 1):
				solid_cells.append(Vector2i(x,y))
				walls.set_cell(Vector2i(x,y), 1, Vector2i(2,2))
	walls.set_cells_terrain_connect(solid_cells,0,0)
	walls.set_cells_terrain_connect(solid_cells,0,0)
	walls.set_cells_terrain_connect(solid_cells,0,0)

pass
		
