class_name BlessingOfLife
extends Disc

func _init() -> void:
	patron = Patron.Euceleph
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.BlessingOfLife)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var bus = Main.main.get_level().event_bus
	bus.register_effect(Timed_LocustSwarm.new(60))
