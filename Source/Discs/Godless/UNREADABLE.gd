class_name UNREADABLE
extends Disc

func _init() -> void:
	patron = Patron.Godless
	rarity = Rarity.Trash
	cost = 1
	super._init(DiscID.UNREADABLE)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.main.add_peril(2)
