class_name PrayerToEuceleph
extends Disc

func _init() -> void:
	patron = Patron.Euceleph
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.PrayerToEuceleph)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var peril = Main.main.get_peril()
	if peril <= 31:
		var plr = Main.main.get_player()
		plr.heal(plr.max_health * 0.31)
