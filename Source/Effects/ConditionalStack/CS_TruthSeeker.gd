class_name CS_TruthSeeker
extends ConditionalStackEffect

func _init(st:int) -> void:
	effect_name = "Truth Seeker"
	icon_atlas = Main.GameAtlas
	icon_index = -1
	super._init(st)

func process_event(event:Event):
	if event is PerilBlockEvent or event is PerilGainEvent:
		stack -= 1
	var bus = Main.main.get_level().event_bus
	bus.register_effect(Timed_SpeedChange.new(0.1,0.4))
	super(event)
