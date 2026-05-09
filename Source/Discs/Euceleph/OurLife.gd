class_name OurLife
extends Disc

func _init() -> void:
	patron = Patron.Euceleph
	rarity = Rarity.Common
	cost = 8
	super._init(DiscID.OurLife)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.main.add_peril(-3)
	Main.main.get_level().drop_on_player(RedBerries)
