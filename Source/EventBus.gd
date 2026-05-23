class_name EventBus
extends Node

var effects:Array[Effect]

func get_effects():
	var name_arr:Array[String]
	for e:Effect in effects:
		name_arr.append(e.effect_name)
	return name_arr

func tick_down(delta: float) -> void:
	var lvl = Main.main.get_level()
	for enemy:Enemy in lvl.enemies.get_children():
		for effect:Effect in enemy.effects:
			if effect is TimedEffect:
				effect.time -= delta
				if effect.time <= 0:
					unregister_effect(effect,enemy.effects)
			else:
					continue
	for effect in effects:
		if effect is TimedEffect:
			effect.time -= delta
			if effect.time <= 0:
				unregister_effect(effect)
		else:
				continue

func process_event(event:Event):
	var lvl = Main.main.get_level()
	for enemy:Enemy in lvl.enemies.get_children():
		for e:Effect in enemy.effects:
			e.process_event(event)
			if e is ConditionalStackEffect and (e as ConditionalStackEffect).stack <= 0:
				unregister_effect(e,enemy.effects)
	for e:Effect in effects:
		e.process_event(event)
		if e is ConditionalStackEffect and (e as ConditionalStackEffect).stack <= 0:
			unregister_effect(e)

func register_effect(effect:Effect,eff_arr:Array[Effect]=effects):
	var effect_check_callable:Callable = func(e:Effect): return e.effect_name == effect.effect_name
	var check_effect_is_there_array:Array[Effect] = eff_arr.filter(effect_check_callable)
	if check_effect_is_there_array.size() < 1:
		eff_arr.append(effect)
	elif effect is TimedEffect:
		(check_effect_is_there_array[0] as TimedEffect).time = effect.time
	elif effect is ConditionalStackEffect:
		(check_effect_is_there_array[0] as ConditionalStackEffect).stack += effect.stack

func unregister_effect(effect:Effect,eff_arr:Array[Effect]=effects):
	var effect_check_callable:Callable = func(e:Effect): return e.effect_name == effect.effect_name
	var check_effect_is_there_array:Array[Effect] = eff_arr.filter(effect_check_callable)
	for eff in check_effect_is_there_array:
		eff_arr.erase(eff)
