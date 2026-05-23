class_name CS_SpeedyShield
extends ConditionalStackEffect

func _init(st:int) -> void:
	effect_name = "Speedy Shield"
	icon_atlas = Main.GameAtlas
	icon_index = 165
	reduce_on_hymn = true
	super._init(st)

func process_event(event:Event):
	if event is PerilBlockEvent:
		var bus = Main.main.get_level().event_bus
		bus.register_effect(Timed_SilentFoot.new(3))
	super(event)
