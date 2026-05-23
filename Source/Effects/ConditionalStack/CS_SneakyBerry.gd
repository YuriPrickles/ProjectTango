class_name CS_SneakyBerry
extends ConditionalStackEffect

func _init(st:int) -> void:
	effect_name = "Sneaky Berry"
	icon_atlas = Main.GameAtlas
	icon_index = 167
	reduce_on_hymn = true
	super._init(st)

func process_event(event:Event):
	if event is EatEvent:
		if event.item.item_name == "ITEM_REDBERRIES":
			var bus = Main.main.get_level().event_bus
			bus.register_effect(Timed_SilentFoot.new(4))
	super(event)
