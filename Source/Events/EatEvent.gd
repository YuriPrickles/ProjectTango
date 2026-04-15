class_name EatEvent
extends Event

var player:Player
var item:Item

func _init(plr:Player,i:Item) -> void:
	player = plr
	item = i
	super._init()
