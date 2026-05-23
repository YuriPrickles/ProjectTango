class_name RecklessCharge
extends Disc

func _init() -> void:
	patron = Patron.Gammon
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.RecklessCharge)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var bus = Main.main.get_level().event_bus
	bus.register_effect(Timed_Reckless.new(4))
