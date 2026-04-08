class_name Effect
extends Node

var effect_id:int = -1
var effect_name = "Effect"
var effect_desc = "Something"
var unremovable = false
var time = 1

func _init(id:int) -> void:
	effect_id = id

func effect_on_player(player:Player):
	pass
func effect_on_enemy(enemy:Enemy):
	pass

static func new_effect(id:int) -> Effect:
	match id:
		EffectID.Passive_ScreamingVoidAxe: return Passive_ScreamingVoidAxe.new(id)
	return null
