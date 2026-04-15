class_name OurGuardian
extends Disc

func _init() -> void:
	patron = Patron.Chlanke
	rarity = Rarity.Common
	cost = 8
	disc_name = "Our Guardian"
	disc_desc = "peril_block += 4"
	super._init(DiscID.OurGuardian)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.main.add_peril_block(4)
