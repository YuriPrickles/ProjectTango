class_name Trap
extends Entity

##For collision, the Rect2's x and y represent offset, while the size is the size.
func _init(pos,collision:Rect2) -> void:
	Utils.attach_collision_shape(self,collision,on_touch_player,on_untouch_player)
	position = pos
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	super._process(delta)

##Override this function for behavior when the player steps on the Trap.
func on_touch_player(body):
	pass

##Override this function for behavior when the player steps off the Trap.
func on_untouch_player(body):
	pass
