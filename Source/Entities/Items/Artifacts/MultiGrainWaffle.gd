class_name MultiGrainWaffle
extends Item

func _init() -> void:
	spr_index = 6
	weapon_type = WeaponType.Regular
	value = Value.Artifact
	item_name = "Multi-Grain Waffle"
	item_desc = "(Passive):\nif event is ConsumeEvent:\nevent.player.heal(10)"
	sell_value = 25
	item_damage = 5
	item_usedelay = 0.5
	passive_effect = Passive_MultiGrainWaffle.new()

func _process(delta: float) -> void:
	super._process(delta)

func on_use() -> bool:
	if not super.on_use(): return false
	var plr:Player = Main.main.get_player()
	Waffle.new(
		null,
		plr.Center - Vector2(0,3) - plr.size/2,
		plr.facing * 2,
		plr.get_damage(item_damage)
		)
	return true
