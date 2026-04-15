class_name TextPopup
extends Node2D

var text:String
var color1:Color
var color2:Color
var target_assigned
var opacity:float = 1.2

func _init(pos:Vector2,txt:String,c1:Color=Main.colors[7],c2:Color=Main.colors[8],targ=null) -> void:
	text = txt
	position = pos
	color1 = c1
	color2 = c2
	z_index = Main.Depths.AbovePlayer
	target_assigned = targ
	var lvl = Main.main.get_level()
	if target_assigned and not lvl.damage_popup_dict.get(targ):
		lvl.damage_popup_dict[target_assigned] = self

func _process(delta: float) -> void:
	queue_redraw()
	opacity -= delta
	if opacity <= 0:
		var lvl = Main.main.get_level()
		if lvl.damage_popup_dict.find_key(self):
			lvl.damage_popup_dict.erase(lvl.damage_popup_dict.find_key(self))
		queue_free()

func _draw() -> void:
	Main.draw_text_centered(self,text,Vector2.ZERO,Utils.blink(color1,color2,8) * opacity,Main.colors[0])
