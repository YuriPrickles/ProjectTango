class_name Timed_LocustSwarm
extends TimedEffect

func _init(t:float) -> void:
	effect_name = "Locust Swarm"
	icon_atlas = Main.GameAtlas
	icon_index = 166
	super._init(t)

func process_event(event:Event):
	var plr = Main.main.get_player()
	if event is MoveEvent and event.mover is Enemy:
			if event.mover.position.distance_to(plr.position) < 32:
				var bus = Main.main.get_level().event_bus
				bus.register_effect(Timed_SpeedChange.new(0.1,-0.31,Enemy),(event.mover as Enemy).effects)
	super(event)
