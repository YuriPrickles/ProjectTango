class_name Search
extends Disc

func _init() -> void:
	patron = Patron.Mirrara
	rarity = Rarity.Common
	cost = 8
	super._init(DiscID.Search)

func on_play(was_destroyed) -> void:
	Main.disc_manager.cut_queue_hymn(MatchLastPatron.new())
	super.on_play(was_destroyed)
