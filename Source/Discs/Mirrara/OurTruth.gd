class_name OurTruth
extends Disc

func _init() -> void:
	patron = Patron.Mirrara
	rarity = Rarity.Common
	cost = 8
	super._init(DiscID.OurTruth)

func on_play(was_destroyed) -> void:
	var bus:EventBus = Main.main.get_level().event_bus
	bus.register_effect(SilentFoot.new(7))
	super.on_play(was_destroyed)
