class_name PrayerToChlanke
extends Disc

func _init() -> void:
	patron = Patron.Chlanke
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.PrayerToChlanke)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var bus = Main.main.get_level().event_bus
	bus.register_effect(CS_SafePlayback.new(3))
	Main.main.add_peril_block(3)
