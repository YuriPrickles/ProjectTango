class_name Regrowth
extends Disc

func _init() -> void:
	patron = Patron.Euceleph
	rarity = Rarity.Common
	cost = 8
	super._init(DiscID.Regrowth)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var plr = Main.main.get_player()
	plr.heal(5)
	if plr.health >= plr.max_health:
		Main.main.get_level().drop_item(RedBerries)
