class_name Heist
extends Disc

func _init() -> void:
	patron = Patron.Gammon
	rarity = Rarity.Common
	cost = 8
	disc_name = "Heist"
	disc_desc = "peril += 3\nlevel.drop_item(BigEepleBag)"
	super._init(DiscID.Heist)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.main.add_peril(3)
	Main.main.current_level.drop_item(BigEepleBag)
