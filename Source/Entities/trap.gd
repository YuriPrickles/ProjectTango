class_name Trap
extends Entity

##For collision, the Rect2's x and y represent offset, while the size is the size.
func _init(pos,collision:Rect2) -> void:
	super._init(pos,collision)
	#Utils.attach_collision_shape(self,collision,on_touch_thing,on_untouch_thing)
	position = pos
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	super._process(delta)

func trigger_trap(plr:Player) -> TriggerTrapEvent:
	var trtevent = TriggerTrapEvent.new(plr,self)
	if not trtevent.trigger_success:
		return trtevent
	return trtevent

##Override this function for behavior when the player steps on the Trap.
func on_touch_thing(body):
	if body is Player:
		trigger_trap(body)
	pass

##Override this function for behavior when the player steps off the Trap.
func on_untouch_thing(body):
	pass
