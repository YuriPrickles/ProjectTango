class_name Metal
extends Item
func _init(id:int) -> void:
	super._init(id)
	sell_value = ResourceManager.scrap_sells[0]
	value = Value.Scraps
	item_name = "Metal"
	item_desc = "Sturdy material for building things."
