class_name PickupLandEvent
extends Event
var pickup:Pickup

func _init(pckup:Pickup) -> void:
	pickup = pckup
	super._init()
