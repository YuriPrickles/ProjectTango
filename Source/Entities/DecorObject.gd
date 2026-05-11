class_name DecorObject
extends StaticBody2D

var spr_dict:Dictionary[int,Vector2]
var offset:Vector2 = Vector2.ZERO
var index_offset:int = 0
var collider:Rect2
var y_sort_offset:int = 0
func _init(col:Rect2) -> void:
	Utils.attach_collision_shape(self,col)

func _process(delta: float) -> void:
	var plr:Player = Main.main.get_player()
	if plr.position.y > position.y + y_sort_offset:
		z_index = Main.Depths.BelowPlayer
	else:
		z_index = Main.Depths.AbovePlayer


func draw_from_dict(spr_dic:Dictionary[int, Vector2], draw_offset:Vector2, spr_index_offset:int):
	for index in spr_dic.keys():
		Main.spr(Main.GameAtlas,self,(draw_offset) + (spr_dict.get(index)) * (Main.SPR_SIZE),spr_index_offset + index)

func _draw() -> void:
	draw_from_dict(spr_dict,offset,index_offset)
