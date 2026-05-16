class_name ConditionalStackEffect
extends Effect

var stack:int
var reduce_on_hymn = false

func _init(st:int) -> void:
	stack = st

func process_event(event:Event):
	super(event)
	if reduce_on_hymn and event is HymnPlayEvent and event.hymn:
		stack -= 1
