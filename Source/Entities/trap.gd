class_name Trap
extends Entity

##For collision, the Rect2's x and y represent offset, while the size is the size.
func _init(pos,collision:Rect2) -> void:
	Utils.attach_collision_shape(self,collision.size,on_touch_player,collision.position)
	position = pos
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

##Override this function for behavior when the player steps on the Trap.
func on_touch_player(body):
	pass

##Override this function for behavior when the player steps off the Trap.
func on_exit_player(body):
	pass
