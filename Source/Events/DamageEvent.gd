class_name DamageEvent
extends Event

var damage:int
var target
var source

func _init(dmg:int,targ, src=null) -> void:
	damage = dmg
	target = targ
	source = src
	assert(targ is Player or targ is Enemy
	,"bro")
	super._init()
