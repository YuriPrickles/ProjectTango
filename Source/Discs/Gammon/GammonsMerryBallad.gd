class_name GammonsMerryBallad
extends Disc

func _init() -> void:
	patron = Patron.Gammon
	rarity = Rarity.Uncommon
	cost = 17
	super._init(DiscID.GammonsMerryBallad)

func on_play(was_destroyed) -> void:
	super.on_play(was_destroyed)
	var lvl = Main.main.get_level()
	var has_artifact = false
	for item:Pickup in lvl.items.get_children():
		if item.item.value == Item.Value.Artifact:
			has_artifact = true
	if has_artifact:
		lvl.event_bus.register_effect(Timed_SpeedChange.new(25,0.4))
	else:
		Main.main.add_peril(7)
