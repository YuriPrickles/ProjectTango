class_name ScreamingVoidAxe
extends Item

func _init(id:int) -> void:
	super._init(id)
	weapon_type = WeaponType.Regular
	value = Value.Artifact
	item_name = "Axe of the Screaming Void"
	item_desc = "(Passive): proj.damage *= lerp(3,0.6,proj.lifetime_percent)"
	sell_value = 25
	item_damage = 3
	item_usedelay = 0.6

func _process(delta: float) -> void:
	super._process(delta)

func on_use() -> bool:
	if not super.on_use(): return false
	var plr:Player = Main.main.get_player()
	Projectile.new_projectile(
		null,
		ProjectileID.AxeBlast,
		plr.Center + (plr.facing * 8),
		plr.facing * 2,
		plr.get_damage(item_damage)
		)
	return true

func passive_effect():
	pass
