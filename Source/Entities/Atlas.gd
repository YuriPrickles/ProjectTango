class_name Atlas
extends Node

var atlas_array:Array[Rect2]
var texture:Texture2D

func _init(tex:Texture2D) -> void:
	texture = tex
	var SPR_COLS = texture.get_height() / Main.SPR_SIZE
	var SPR_ROWS = texture.get_width() / Main.SPR_SIZE
	atlas_array.resize(SPR_COLS * SPR_ROWS)
	for i in range(texture.get_height() / Main.SPR_SIZE):
		for j in range(texture.get_width() / Main.SPR_SIZE):
			atlas_array[(j + (i * texture.get_width() / Main.SPR_SIZE))] = Rect2(Vector2(j,i) * Main.SPR_SIZE, Vector2(Main.SPR_SIZE,Main.SPR_SIZE)) 
		pass

func draw_from_atlas(item:RID, offset:Vector2,index:int):
	texture.draw_rect_region(item,Rect2(offset,Vector2(Main.SPR_SIZE,Main.SPR_SIZE)),atlas_array[index])
