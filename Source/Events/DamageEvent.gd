class_name DamageEvent
extends Event

var damage:int
var target
var source
var player_hurt = false

func _init(dmg:int,targ, src=null) -> void:
	damage = dmg
	target = targ
	source = src
	player_hurt = target is Player
	assert(targ is Player or targ is Enemy
	,"bro")
	super._init()
	
	var lvl = Main.main.get_level()
	if targ:
		if lvl.damage_popup_dict.get(targ):
			var popup:TextPopup = lvl.damage_popup_dict.get(targ)
			popup.position = targ.position + Vector2(0,-16)
			popup.text = str(popup.text.to_int() + damage)
			popup.opacity = 1.2
		else:
			Main.main.text_popup(target.position,str(damage),Main.colors[7],Main.colors[8],targ)
