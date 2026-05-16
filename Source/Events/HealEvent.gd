class_name HealEvent
extends Event

var healed_amount:int

func _init(heal:int) -> void:
	healed_amount = heal
	super._init()
