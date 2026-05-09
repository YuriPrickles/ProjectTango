class_name PrairieKingGun
extends Item

func _init() -> void:
	spr_index = 8
	weapon_type = WeaponType.Regular
	value = Value.Artifact
	sell_value = 25
	item_damage = 2
	item_usedelay = 0.24
	passive_effect = Passive_PrairieKingGun.new()
	super()

func _process(delta: float) -> void:
	super._process(delta)

func on_use() -> bool:
	if not super.on_use(): return false
	var plr:Player = Main.main.get_player()
	Bullet.new(
		null,
		plr.position - Vector2(2 + plr.facing.y * 2,0) + plr.facing * 4,
		plr.facing * 2,
		plr.get_damage(item_damage)
		)
	return true

class Passive_PrairieKingGun:
	extends Effect
	
	func _init() -> void:
		effect_name = "Rapid Reload"
		icon_atlas = Main.ItemAtlas
		icon_index = 8
	
	func process_event(event:Event):
		if event is ItemUseEvent:
			event.usedelay_mod *= 0.9
