extends Node2D
class_name Splitter
var root_node: Branch
var tile_size: int = 8
var tilemap:TileMapLayer
var paths: Array = []
var floor_size = Vector2i(120, 80)
var rooms:Array
var artifact_rooms:Array[Branch]
var splitiness = 6

func _ready():
	root_node  = Branch.new(Vector2i(0, 0), floor_size) # 60 tiles wide and 30 tall
	root_node.split(splitiness, paths)
	rooms = root_node.get_leaves()
	
	var artifact_room_index = randi_range((int)((pow(2,splitiness + 1)) * 0.75),pow(2,splitiness + 1)) - 1
	print(artifact_room_index)
	artifact_rooms.append(rooms[artifact_room_index])
	#for leaf:Branch in rooms:
		#if rooms.find(leaf) == rooms.size() - 1:
			#print(leaf.position)
			#artifact_rooms.append(leaf)
	queue_redraw()


static var padding = Vector4i(0,0,1,1)

static func is_inside_padding(x, y, leaf, pad):
	return x <= pad.x or y <= pad.y or x >= leaf.size.x - pad.z or y >= leaf.size.y - pad.w

var solid_cells:Array[Vector2i]

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
	if tilemap == null: return
	for leaf in root_node.get_leaves():
		for x in range(leaf.size.x):
			for y in range(leaf.size.y):
				var tilepos = Vector2i(x + leaf.position.x,y + leaf.position.y)
				if not is_inside_padding(x,y, leaf, padding):
					tilemap.set_cell(tilepos, 1, Vector2i(1, 7))
				else:
					solid_cells.append(tilepos)
					tilemap.set_cell(tilepos, 1, Vector2i(0, 5))
	for path in paths:
		for i in range(path['right'].x - path['left'].x):
			solid_cells.erase(path['left']+Vector2i(i,0))
			tilemap.set_cell(Vector2i(path['left'].x+i,path['left'].y), 1, Vector2i(1, 7))
		for i in range(path['right'].y - path['left'].y):
			solid_cells.erase(path['left']+Vector2i(0,i))
			tilemap.set_cell(Vector2i(path['left'].x,path['left'].y+i), 1, Vector2i(1, 7))
	for x in range(-1, floor_size.x + 1):
		for y in range(-1, floor_size.y + 1):
			if (x < 0 or x > floor_size.x - 1) or (y < 0 or y > floor_size.y - 1):
				solid_cells.append(Vector2i(x,y))
				tilemap.set_cell(Vector2i(x,y), 1, Vector2i(2,2))
	tilemap.set_cells_terrain_connect(solid_cells,0,0)
	tilemap.set_cells_terrain_connect(solid_cells,0,0)
	tilemap.set_cells_terrain_connect(solid_cells,0,0)

pass
		
