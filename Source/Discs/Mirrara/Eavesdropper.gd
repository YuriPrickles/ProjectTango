class_name Eavesdropper
extends Disc

func _init() -> void:
	patron = Patron.Mirrara
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.Eavesdropper)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var bus = Main.main.get_level().event_bus
	bus.register_effect(Timed_SilentFoot.new(12))
	bus.register_effect(Timed_SpeedChange.new(12,0.4))
