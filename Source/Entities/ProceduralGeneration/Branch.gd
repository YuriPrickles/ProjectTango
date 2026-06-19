extends Node
class_name Branch

var left_child: Branch
var guaranteed_path:Dictionary
var right_child: Branch
var position: Vector2i
var size: Vector2i

func _init(position, size):
	self.position = position
	self.size = size

func get_leaves():
	if not (left_child && right_child):
		return [self]
	else:
		return left_child.get_leaves() + right_child.get_leaves()

func get_center() -> Vector2i:
	return Vector2i(position.x + size.x / 2, position.y + size.y / 2)
func rand_path_range(from, to, rng:RandomNumberGenerator=RandomNumberGenerator.new()) -> Vector2i:
	return Vector2i(rng.randi_range(from,to),rng.randi_range(from,to))

func split(remaining, paths:Array):
	var rng = RandomNumberGenerator.new()
	
	var split_percent = rng.randf_range(0.3,0.7) # splits will be between 30% and 70%
	var split_horizontal = size.y >= size.x # if it is taller than it is wide
	if(split_horizontal):
		# horizontal
		var left_height = int(size.y * split_percent)
		left_child = Branch.new(position, Vector2i(size.x, left_height))
		right_child = Branch.new(
			Vector2i(position.x, position.y + left_height), 
			Vector2i(size.x, size.y - left_height)
		)
	else:
		# vertical
		var left_width = int(size.x * split_percent)
		left_child = Branch.new(position, Vector2i(left_width, size.y))
		right_child = Branch.new(
			Vector2i(position.x + left_width, position.y), 
			Vector2i(size.x - left_width, size.y)
		)
	
	if randi_range(0,100) <= 5:
		var path:Dictionary = {'left': left_child.get_center() + 4 * rand_path_range(-4,4,rng),
								'right': right_child.get_center() + 4 * rand_path_range(-4,4,rng)}
		if ((path.get("left").x < 1 or path.get("left").x > 1) and 
			(path.get("right").x < 1 or path.get("right").x > 1)):
				if not paths.has(path):
					paths.push_back(path)
				else:
					print("duplicate!")
	guaranteed_path = {'left': left_child.get_center(),
						'right': right_child.get_center()}
	paths.push_back(guaranteed_path)
	
	if(remaining > 0):
		left_child.split(remaining - 1, paths)
		right_child.split(remaining - 1, paths)
