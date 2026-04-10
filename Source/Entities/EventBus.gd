class_name EventBus
extends Node

var effects:Array[Effect]

func get_effects():
	var name_arr:Array[String]
	for e:Effect in effects:
		name_arr.append(e.effect_name)
	return name_arr

func process_event(event:Event):
	for e:Effect in effects:
		e.process_event(event)

func register_effect(effect:Effect):
	if effects.filter(func(e:Effect): return e.effect_name == effect.effect_name).size() < 1:
		effects.append(effect)

func unregister_effect(effect:Effect):
	effects.erase(effect)
