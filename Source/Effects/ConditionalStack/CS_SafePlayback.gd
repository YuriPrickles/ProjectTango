class_name CS_SafePlayback
extends ConditionalStackEffect

func _init(st:int) -> void:
	effect_name = "Safe Playback"
	icon_atlas = Main.GameAtlas
	icon_index = 100
	reduce_on_hymn = true
	super._init(st)

func process_event(event:Event):
	if event is HymnPlayEvent:
		if event.hymn:
			event.hymn.protected = true
	super(event)
