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
var dmg_source_name:String=""
var name_file:String="res://Source/Names/snitchweed.txt"
var peril_affection_thresholds:Array[int]=[]
var unreality_affection_thresholds:Array[int]=[]
var y_sort_offset:int = 0
var solid = false
var spr_dict:Dictionary[int,Vector2]

func _init(pos,collision:Rect2,_solid=false) -> void:
	var file = FileAccess.open(name_file, FileAccess.READ)
	var name_arr:PackedStringArray = file.get_as_text().split("\n")
	while dmg_source_name.is_empty():
		dmg_source_name = name_arr[randi() % name_arr.size() - 1]
	if _solid:
		solid = true
		var static_body = StaticBody2D.new()
		Utils.attach_collision_shape(static_body,collision,on_touch_thing,on_untouch_thing)
	Utils.attach_collision_shape(self,collision,on_touch_thing,on_untouch_thing)
	position = pos
	offset = collision.size
	queue_redraw()

func _process(delta: float) -> void:
	var plr:Player = Main.main.get_player()
	if plr.position.y > position.y + y_sort_offset:
		z_index = Main.Depths.BelowPlayer
	else:
		z_index = Main.Depths.AbovePlayer
##Override this function for behavior when the player collides with the enemy.
func on_touch_thing(body):
	pass
func on_untouch_thing(body):
	pass

func draw_from_dict(spr_dict:Dictionary[int, Vector2], draw_offset:Vector2, spr_index_offset:int):
	for index in spr_dict.keys():
		Main.spr(Main.GameAtlas,self,(draw_offset) + (spr_dict.get(index)) * (Main.SPR_SIZE),spr_index_offset + index)
