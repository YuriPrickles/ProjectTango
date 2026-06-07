class_name UndeadChisel
extends Item

func _init() -> void:
	spr_index = 10
	weapon_type = WeaponType.Regular
	value = Value.Artifact
	sell_value = 25
	item_damage = 3
	item_usedelay = 0.4
	item_auto = false
	passive_effect = Passive_UndeadChisel.new()
	super()

var combo_decay_timer:float = 0
const combo_decay:float = 0.7
func _process(delta: float) -> void:
	super._process(delta)
	if combo > 0:
		combo_decay_timer += delta
		if combo_decay_timer >= combo_decay:
			combo = 0
			combo_decay_timer = 0

var use_dir:Vector2 = Vector2(1,0)
var combo = 0
const combo_mult = 0.4
func on_use() -> bool:
	if not super.on_use(): return false
	var plr:Player = Main.main.get_player()
	use_dir = plr.facing
	ChiselSwipe.new(
		null,
		plr.position,
		plr.facing * 0,
		plr.get_damage(item_damage * (1 + (combo_mult * combo))),
		use_dir,
		combo
		)
	combo_decay_timer = 0
	combo += 1
	if combo >= 3:
		combo = 0
		var last_combo_delay_mult :float = 1.2
		item_timer += item_usedelay * last_combo_delay_mult
	return true

class Passive_UndeadChisel:
	extends Effect

	func _init() -> void:
		effect_name = "Scrap Sculptor"
		icon_atlas = Main.ItemAtlas
		icon_index = 10

	func process_event(event:Event):
		if event is DamageEvent:
			if event.target is Enemy and event.source is Projectile:
				var proj:Projectile = event.source
				if proj.hostile: return
				if randi() % 100 < 4:
					var lvl = Main.main.get_level()
					lvl.drop_item_somewhere(event.target.position,Item.scraps.pick_random())
