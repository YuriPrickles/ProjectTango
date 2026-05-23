class_name CS_SheriffsGaze
extends ConditionalStackEffect

func _init(st:int) -> void:
	effect_name = "Sheriffs Gaze"
	icon_atlas = Main.GameAtlas
	icon_index = 171
	reduce_on_hymn = true
	super._init(st)

func process_event(event:Event):
	if event is PerilGainEvent:
		Main.main.resources.add_money(2)
	super(event)
