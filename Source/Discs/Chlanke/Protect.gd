class_name Protect
extends Disc

func _init() -> void:
	patron = Patron.Chlanke
	rarity = Rarity.Common
	cost = 8
	disc_name = "Protect"
	disc_desc = "peril_block += 2\nif event is DamageEvent and event.player_hurt:\nevent.damage *= 0.75"
	super._init(DiscID.Protect)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.main.add_peril_block(2)
	var bus = Main.main.get_level().event_bus
	bus.register_effect(CS_Protect.new(1))
