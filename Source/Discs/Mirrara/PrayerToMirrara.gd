class_name PrayerToMirrara
extends Disc

func _init() -> void:
	patron = Patron.Mirrara
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.PrayerToMirrara)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var bus = Main.main.get_level().event_bus
	for i in range(2): Main.main.disc_manager.cut_queue_hymn(IsMirrara.new())
	bus.register_effect(CS_HymnPlayDelay.new(2,10))
