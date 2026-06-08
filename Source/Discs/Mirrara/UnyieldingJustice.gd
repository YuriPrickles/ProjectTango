class_name UnyieldingJustice
extends Disc

func _init() -> void:
	patron = Patron.Mirrara
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.UnyieldingJustice)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	for i in range(2):
		if Main.main.disc_manager.hymn_buffer[i]:
			Main.main.disc_manager.hymn_buffer[i].replayable = true
