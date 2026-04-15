class_name Passive_ScreamingVoidAxe
extends Effect

func _init() -> void:
	effect_name = "Void Shredder"

func process_event(event:Event):
	if event is DamageEvent:
		if event.target is Enemy and event.source is Projectile:
			var proj:Projectile = event.source
			var max_distance_dmg_dropoff = 75
			var distance_percent = min(1,
			proj.starting_pos.distance_to(proj.ending_pos) / max_distance_dmg_dropoff)
			event.damage *= lerp(3.0,0.6,distance_percent)
