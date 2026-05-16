class_name DivineDoctor
extends Disc

func _init() -> void:
	patron = Patron.Chlanke
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.DivineDoctor)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var bus = Main.main.get_level().event_bus
	bus.register_effect(CS_HealToPB.new(2))
