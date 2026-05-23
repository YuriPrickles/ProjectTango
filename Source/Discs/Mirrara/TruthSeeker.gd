class_name TruthSeeker
extends Disc

func _init() -> void:
	patron = Patron.Mirrara
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.TruthSeeker)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var bus:EventBus = Main.main.get_level().event_bus
	bus.register_effect(CS_TruthSeeker.new(1))
