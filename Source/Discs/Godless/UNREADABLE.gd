class_name UNREADABLE
extends Disc

func _init() -> void:
	patron = Patron.Godless
	rarity = Rarity.Common
	cost = 1
	disc_name = "UNREADABLE FILE"
	disc_desc = "+2 PERIL"
	super._init(DiscID.UNREADABLE)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.main.add_peril(2)
