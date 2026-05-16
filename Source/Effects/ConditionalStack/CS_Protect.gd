class_name CS_Protect
extends ConditionalStackEffect

func _init(st:int) -> void:
	effect_name = "Protect"
	icon_atlas = Main.GameAtlas
	icon_index = 26
	super._init(st)

func process_event(event:Event):
	if event is DamageEvent and event.player_hurt:
		(event as DamageEvent).damage = floori(float((event as DamageEvent).damage) * 0.75)
		stack -= 1
	super(event)
