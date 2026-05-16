class_name EventBus
extends Node

var effects:Array[Effect]

func get_effects():
	var name_arr:Array[String]
	for e:Effect in effects:
		name_arr.append(e.effect_name)
	return name_arr

func tick_down(delta: float) -> void:
	for effect in effects:
		if effect is TimedEffect:
			effect.time -= delta
			if effect.time <= 0:
				unregister_effect(effect)
		else:
				continue

func process_event(event:Event):
	for e:Effect in effects:
		e.process_event(event)
		if e is ConditionalStackEffect and (e as ConditionalStackEffect).stack <= 0:
			unregister_effect(e)

func register_effect(effect:Effect):
	var effect_check_callable:Callable = func(e:Effect): return e.effect_name == effect.effect_name
	var check_effect_is_there_array:Array[Effect] = effects.filter(effect_check_callable)
	if check_effect_is_there_array.size() < 1:
		effects.append(effect)
	elif effect is TimedEffect:
		(check_effect_is_there_array[0] as TimedEffect).time += effect.time
	elif effect is ConditionalStackEffect:
		(check_effect_is_there_array[0] as ConditionalStackEffect).stack += effect.stack

func unregister_effect(effect:Effect):
	var effect_check_callable:Callable = func(e:Effect): return e.effect_name == effect.effect_name
	var check_effect_is_there_array:Array[Effect] = effects.filter(effect_check_callable)
	for eff in check_effect_is_there_array:
		effects.erase(eff)
