class_name OurBounty
extends Disc

func _init() -> void:
	patron = Patron.Gammon
	rarity = Rarity.Common
	cost = 8
	super._init(DiscID.OurBounty)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.main.current_level.spawn_scrap(2)
