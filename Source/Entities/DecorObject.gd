class_name DecorObject
extends Entity

var index_offset:int = 0
var collider:Rect2
func _init(pos, col:Rect2,_solid=true) -> void:
	super(pos, col,_solid)

func _process(delta: float) -> void:
	super(delta)


func draw_from_dict(spr_dic:Dictionary[int, Vector2], draw_offset:Vector2, spr_index_offset:int):
	for index in spr_dic.keys():
		Main.spr(Main.GameAtlas,self,(draw_offset) + (spr_dict.get(index)) * (Main.SPR_SIZE),spr_index_offset + index)

func _draw() -> void:
	draw_from_dict(spr_dict,offset,index_offset)
