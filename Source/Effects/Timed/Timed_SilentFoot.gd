class_name SilentFoot
extends TimedEffect

func _init(t:float) -> void:
	effect_name = "Silent Foot"
	icon_atlas = Main.GameAtlas
	icon_index = 27
	super._init(t)

func process_event(event:Event):
	if event is TriggerTrapEvent:
		event.trigger_success = false
	super(event)
