class_name MoveEvent
extends Event

var speedmod:float
var mover

func _init(spdmd:int,targ) -> void:
	speedmod = spdmd
	mover = targ
	assert(targ is Player or targ is Enemy
	,"bro")
	super._init()
