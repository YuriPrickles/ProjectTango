class_name BlessOurSouls
extends Disc

func _init() -> void:
	patron = Patron.Chlanke
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.BlessOurSouls)

func on_play(was_destroyed) -> void:
	var plr = Main.main.get_player()
	var pb_gained = (plr.max_health - plr.health) / 5
	Main.main.add_peril_block(pb_gained)
