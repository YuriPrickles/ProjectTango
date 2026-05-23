class_name OurTruth
extends Disc

func _init() -> void:
	patron = Patron.Mirrara
	rarity = Rarity.Common
	cost = 8
	super._init(DiscID.OurTruth)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var bus:EventBus = Main.main.get_level().event_bus
	bus.register_effect(Timed_SilentFoot.new(7))
