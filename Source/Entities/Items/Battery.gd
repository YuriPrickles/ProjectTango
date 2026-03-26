class_name Battery
extends Item
func _init(id:int) -> void:
	super._init(id)
	sell_value = ResourceManager.scrap_sells[2]
	value = Value.Scraps
	item_name = "Battery"
	item_desc = "All melded into one singular being"
