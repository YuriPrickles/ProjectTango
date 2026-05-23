class_name TheBoyWhoBrokeDoors
extends Disc

func _init() -> void:
	patron = Patron.Gammon
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.TheBoyWhoBrokeDoors)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.main.add_peril(5)
	Main.main.current_level.spawn_scrap(7)
