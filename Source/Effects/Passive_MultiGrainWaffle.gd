class_name Passive_MultiGrainWaffle
extends Effect

func _init() -> void:
	effect_name = "Yummy Blessing"

func process_event(event:Event):
	if event is EatEvent:
		if event.player and event.item:
			var plr : Player = event.player
			plr.heal(10)
			pass
