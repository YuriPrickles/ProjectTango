class_name Entity
extends Area2D

var width: float
var height: float
var offset: Vector2:
	get: return offset
	set(value): offset = value
var Center:
	get: return position + (Vector2(width,height) / 2)
var int_position: Vector2i:
	get: return Vector2i(position)

func _init(pos,collision:Rect2) -> void:
	Utils.attach_collision_shape(self,collision,on_touch_player,on_untouch_player)
	position = pos
	offset = collision.size
	
func _process(delta: float) -> void:
	var plr:Player = Main.main.get_player()
	if plr.position.y > position.y:
		z_index = Main.Depths.BelowPlayer
	else:
		z_index = Main.Depths.AbovePlayer
	pass
##Override this function for behavior when the player collides with the enemy.
func on_touch_player(body):
	pass
func on_untouch_player(body):
	pass

func draw_from_dict(spr_dict:Dictionary[int, Vector2], draw_offset:Vector2, spr_index_offset:int):
	for index in spr_dict.keys():
		Main.spr(Main.GameAtlas,self,(draw_offset) + (spr_dict.get(index)) * (Main.SPR_SIZE),spr_index_offset + index)
