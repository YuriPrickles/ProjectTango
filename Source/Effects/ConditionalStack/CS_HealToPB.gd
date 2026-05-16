class_name CS_HealToPB
extends ConditionalStackEffect

func _init(st:int) -> void:
	effect_name = "Heal to PB"
	icon_atlas = Main.GameAtlas
	icon_index = 99
	reduce_on_hymn = true
	super._init(st)

func process_event(event:Event):
	if event is HealEvent and event.healed_amount > 0:
		Main.main.add_peril_block(event.healed_amount * 0.2)
		event.healed_amount *= 0.8
	super(event)
