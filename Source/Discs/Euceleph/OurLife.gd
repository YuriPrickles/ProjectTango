class_name OurLife
extends Disc

func _init() -> void:
	patron = Patron.Euceleph
	rarity = Rarity.Common
	cost = 8
	disc_name = "Our Life"
	disc_desc = "-2 PERIL"
	super._init(DiscID.OurLife)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.main.add_peril(-2)
