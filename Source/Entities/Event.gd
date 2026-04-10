class_name Event
extends Object

func _init() -> void:
	var bus = Main.main.get_level().event_bus
	bus.process_event(self)
