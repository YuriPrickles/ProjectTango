class_name ScreamingVoidAxe
extends Item

func _init() -> void:
	spr_index = 5
	weapon_type = WeaponType.Regular
	value = Value.Artifact
	sell_value = 25
	item_damage = 1
	item_usedelay = 0.6
	passive_effect = Passive_ScreamingVoidAxe.new()
	super()

func _process(delta: float) -> void:
	super._process(delta)

func on_use() -> bool:
	if not super.on_use(): return false
	var plr:Player = Main.main.get_player()
	AxeBlast.new(
		null,
		plr.position + (plr.facing * 6),
		plr.facing * 2,
		plr.get_damage(item_damage)
		)
	return true

class Passive_ScreamingVoidAxe:
	extends Effect

	func _init() -> void:
		effect_name = "Void Shredder"
		icon_atlas = Main.ItemAtlas
		icon_index = 5

	func process_event(event:Event):
		if event is DamageEvent:
			if event.target is Enemy and event.source is Projectile:
				var proj:Projectile = event.source
				if proj.hostile: return
				var max_distance_dmg_dropoff = 30
				var distance_percent = min(1,
				proj.starting_pos.distance_to(proj.ending_pos) / max_distance_dmg_dropoff)
				var crit_chance = lerp(0.2,0.0,distance_percent)
				if randf_range(0,1) <= crit_chance:
					event.damage *= 3
					event.crit = true
