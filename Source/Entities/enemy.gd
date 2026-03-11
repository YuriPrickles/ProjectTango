class_name Enemy
extends Entity

var enemy_name="The Nameless"
var Health:int
var MaxHealth:int
var navigator:NavigationAgent2D
func set_movement_target(movement_target: Vector2):
	navigator.target_position = movement_target
##For collision, the Rect2's x and y represent offset, while the size is the size.
func _init(pos,collision:Rect2) -> void:
	Utils.attach_collision_shape(self,collision.size,on_touch_player,collision.position)
	position = pos

	
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var plr:Player = Main.main.get_player()
	if plr.position.y > position.y:
		z_index = Main.Depths.Enemies
	else:
		z_index = Main.Depths.AbovePlayer
	pass

##Override this function for behavior when the player collides with the enemy.
func on_touch_player(body):
	pass

func _draw() -> void:
	pass
