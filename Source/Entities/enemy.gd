class_name Enemy
extends Entity

var Health:int
var MaxHealth:int
var navigator:NavigationAgent2D
func set_movement_target(movement_target: Vector2):
	navigator.target_position = movement_target
##For collision, the Rect2's x and y represent offset, while the size is the size.
func _init(pos,collision:Rect2) -> void:
	super._init(pos,collision)

	
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	super._process(delta)



func _draw() -> void:
	pass
