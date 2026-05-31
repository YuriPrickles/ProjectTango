class_name TwigPile
extends Enemy
var kb_dir:Vector2
func _init(pos) -> void:
	super._init(pos,Rect2(4,4,8,8))
	spr_dict={
		119:Vector2(0,0)
	}
	Health = 15
	
	MaxHealth = 15

func _process(delta: float) -> void:
	super._process(delta)
	var plr:Player = Main.main.get_player()
	if plr and plr.position.distance_to(position) < 32:
		kb_dir = (position + offset).direction_to(plr.position)
func on_touch_thing(body):
	if body is Player:
		body.knockback(kb_dir, 200)
		hurt(3,self)
func _draw() -> void:
	draw_from_dict(spr_dict,offset,0)
