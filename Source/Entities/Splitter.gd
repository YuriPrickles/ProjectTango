extends Node2D
class_name Splitter
var root_node: Branch
var tile_size: int = 8
var walls:TileMapLayer
var floor:TileMapLayer
var paths: Array = []
var floor_size = Vector2i(120, 80)
var rooms:Array
var guaranteed_paths:Array[Dictionary]
var artifact_rooms:Array[Branch]
var splitiness = 6

func _ready():
	root_node  = Branch.new(Vector2i(0, 0), floor_size)
	root_node.split(splitiness, paths)
	rooms = root_node.get_leaves()
	var artifact_room_index = randi_range((int)((pow(2,splitiness + 1)) * 0.75),pow(2,splitiness + 1)) - 1
	artifact_rooms.append(rooms[min(artifact_room_index, rooms.size()-1)])
	queue_redraw()

var padding = Vector4i(0,0,1,1)

static func is_inside_padding(x, y, leaf, pad):
	return x <= pad.x or y <= pad.y or x >= leaf.size.x - pad.z or y >= leaf.size.y - pad.w

var solid_cells:Array[Vector2i]

##This assumes you set up your tileset correctly.[br]
##If you didn't set up the tilesheet right we will put you in the contraption.[br]
##initial_pos refers to the default floor tile which will be the most common. (70% of floor tiles)
func get_floor_tile(initial_pos:Vector2i) -> Vector2i:
	if randi() % 10 > 7:
		return initial_pos + Vector2i(randi() % 3 - 1, 2)
	return initial_pos
