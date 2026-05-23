class_name HymnPlayEvent
extends Event

var hymn:Disc
var next_hymn_delay:int
var next_disc_condition:DiscCondition

func _init(hy:Disc,delay:int=DiscManager.HYMN_DELAY,cond:DiscCondition=null) -> void:
	hymn = hy
	next_hymn_delay = delay
	next_disc_condition = cond
	super._init()
