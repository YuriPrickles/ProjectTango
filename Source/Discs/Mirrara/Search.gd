class_name Search
extends Disc

func _init() -> void:
	patron = Patron.Mirrara
	rarity = Rarity.Common
	cost = 8
	super._init(DiscID.Search)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	Main.disc_manager.cut_queue_hymn(MatchLastPatron.new())
