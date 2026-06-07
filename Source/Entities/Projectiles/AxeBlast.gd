class_name AxeBlast
extends Projectile
var radius:float = 0
func _init(p_owner:Entity,pos:Vector2,_velocity:Vector2,_damage:int) -> void:
	super._init(p_owner,pos,Rect2(0,0,0,0),_velocity,false,_damage,-1,9)
	z_index = Main.Depths.Level
	offset = Vector2(4,4)
	hostile = false
	clear_collisions()
	Utils.attach_round_collision_shape(self,8,on_touch_thing,offset)
	var tween = create_tween()
	tween.tween_property(self,"radius",8,0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free)

func handle_wall_col():
	pass

func _process(delta: float) -> void:
	super._process(delta)
	for en in get_overlapping_areas():
		if en is Enemy:
			en.hurt(damage,self,0.03)

func _draw() -> void:
	var plr := Main.main.get_player()
	draw_circle(offset,radius,Main.colors[Utils.blink(11,7,3)])
	draw_circle(offset + position.direction_to(plr.Center) * 2,radius - 2,Main.colors[Utils.blink(0,2,3)])
