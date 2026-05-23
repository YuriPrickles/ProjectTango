class_name TheSheriffsGaze
extends Disc

func _init() -> void:
	patron = Patron.Gammon
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.TheSheriffsGaze)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var bus = Main.main.get_level().event_bus
	bus.register_effect(CS_SheriffsGaze.new(1))
