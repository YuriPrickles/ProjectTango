class_name Timed_Reckless
extends TimedEffect

func _init(t:float) -> void:
	effect_name = "Reckless Charge"
	icon_atlas = Main.GameAtlas
	icon_index = 172
	super._init(t)

var total_damage:int = 0
func process_event(event:Event):
	if event is DamageEvent and event.player_hurt:
		total_damage += (event as DamageEvent).damage
		if total_damage >= 10:
			var lvl = Main.main.get_level()
			lvl.drop_item(BigEepleBag,3)
			lvl.spawn_scrap(8)
			time = 0
			total_damage = 0
	super(event)
