class_name SilentFoot
extends TimedEffect

func _init(t:float) -> void:
	effect_name = "Silent Foot"
	super._init(t)

func process_event(event:Event):
	if event is TriggerTrapEvent:
		event.trigger_success = false
