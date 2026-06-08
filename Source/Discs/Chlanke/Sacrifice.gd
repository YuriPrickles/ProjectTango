class_name Sacrifice
extends Disc

func _init() -> void:
	patron = Patron.Chlanke
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.Sacrifice)

func on_play(was_destroyed) -> void:
	for i in range(2):
		Main.main.disc_manager.skip_next()
	Main.main.add_peril_block(10)
