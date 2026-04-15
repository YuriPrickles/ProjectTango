class_name Regrowth
extends Disc

func _init() -> void:
	patron = Patron.Euceleph
	rarity = Rarity.Common
	cost = 8
	disc_name = "Regrowth"
	disc_desc = "plr.heal(5)\nif plr.health >= plr.max_health:\nlevel.drop_item(redberries,1)"
	super._init(DiscID.Regrowth)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var plr = Main.main.get_player()
	plr.heal(5)
	if plr.health >= plr.max_health:
		Main.main.get_level().drop_item(RedBerries)
