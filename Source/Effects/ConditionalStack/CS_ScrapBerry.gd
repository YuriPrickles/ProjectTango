class_name CS_ScrapBerry
extends ConditionalStackEffect

func _init(st:int) -> void:
	effect_name = "Scrap Berry"
	icon_atlas = Main.GameAtlas
	icon_index = 115
	reduce_on_hymn = true
	super._init(st)

func process_event(event:Event):
	if event is PickupLandEvent:
		if event.pickup.item.value == Item.Value.Scraps and event.pickup.item.sell_value >= 4:
			event.pickup.item = RedBerries.new()
	super(event)
