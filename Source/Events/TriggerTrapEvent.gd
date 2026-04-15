class_name TriggerTrapEvent
extends Event

var trap:Trap
var plr:Player
var trigger_success:bool = true

func _init(p:Player,t:Trap) -> void:
	plr = p
	trap = t
	super._init()
