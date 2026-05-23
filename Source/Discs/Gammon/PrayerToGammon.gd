class_name PrayerToGammon
extends Disc

func _init() -> void:
	patron = Patron.Gammon
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.PrayerToGammon)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var total_eeples = 0
	var total_peril = 0
	for item:Item in Main.main.resources.inventory:
		if item:
			total_eeples += item.sell_value
			total_peril += 3 * (1 if item.value != Item.Value.Artifact else 2)
	Main.main.resources.add_money(total_eeples / 2)
	Main.main.add_peril(total_peril)
