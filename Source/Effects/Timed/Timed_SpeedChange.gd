class_name Timed_SpeedChange
extends TimedEffect

var strength:float
var target:Script
func _init(t:float, strg:float, targ:Script=Player) -> void:
	effect_name = "Speed Change"
	time = t
	strength = strg
	icon_index = 168 + max(0, sign(strg))
	target = targ
	super(t)

func process_event(event:Event):
	if target.new() is Player:
		if event is MoveEvent and event.mover is Player:
			event.speedmod = strength
	if target.new() is Enemy:
		if event is MoveEvent and event.mover is Enemy:
			event.speedmod = strength
