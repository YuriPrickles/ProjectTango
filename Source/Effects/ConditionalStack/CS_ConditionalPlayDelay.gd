class_name CS_HymnPlayDelay
extends ConditionalStackEffect
var delay:float
func _init(st:int,dly:float) -> void:
	effect_name = "Hymn Delay"
	icon_atlas = Main.GameAtlas
	icon_index = 116
	reduce_on_hymn = true
	delay = dly
	super._init(st)

func process_event(event:Event):
	if event is HymnPlayEvent:
		event.next_hymn_delay = delay
	super(event)
