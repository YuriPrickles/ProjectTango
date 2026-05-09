class_name Protect
extends Disc

func _init() -> void:
	patron = Patron.Chlanke
	rarity = Rarity.Common
	cost = 8
	super._init(DiscID.Protect)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.main.add_peril_block(2)
	var bus = Main.main.get_level().event_bus
	bus.register_effect(CS_Protect.new(1))
