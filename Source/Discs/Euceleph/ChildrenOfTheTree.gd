class_name ChildrenOfTheTree
extends Disc

func _init() -> void:
	patron = Patron.Euceleph
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.ChildrenOfTheTree)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var peril = Main.main.get_peril()
	Main.main.add_peril(Main.main.get_peril_block() * -1)
	Main.main.add_peril_block(peril * -1)
