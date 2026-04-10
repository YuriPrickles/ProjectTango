class_name OurTruth
extends Disc

func _init() -> void:
	patron = Patron.Mirrara
	rarity = Rarity.Common
	cost = 8
	disc_name = "Our Truth"
	disc_desc = "IGNORE NEXT TRAP -> 03s SILENT FOOT"
	super._init(DiscID.OurTruth)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
