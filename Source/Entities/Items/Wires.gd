class_name Wires
extends Item
func _init(id:int) -> void:
	super._init(id)
	sell_value = ResourceManager.scrap_sells[1]
	value = Value.Scraps
	item_name = "Wires"
	item_desc = "Slightly Chewed"
