class_name CS_GitsPlayDelay
extends ConditionalStackEffect
func _init(st:int) -> void:
	effect_name = "Git's Hymn Delay"
	icon_atlas = Main.GameAtlas
	icon_index = 173
	super._init(st)

func process_event(event:Event):
	if event is HymnPlayEvent:
		event.next_hymn_delay *= 2
	super(event)
