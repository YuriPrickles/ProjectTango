class_name SquallitaShockwave
extends Projectile
var radius = 0
func _init(p_owner:Entity,id,pos:Vector2,_velocity:Vector2,_damage:int) -> void:
	super._init(p_owner,pos,Rect2(0,0,0,0),id,_velocity,false,_damage,1,9)
	z_index = Main.Depths.Level
	spr_dict = {
		107: Vector2(0,0),
		108: Vector2(0,0),
		123: Vector2(0,0),
		124: Vector2(0,0),
	}
	offset = Vector2(4,4)
	hostile = false
	clear_collisions()
	Utils.attach_round_collision_shape(self,8,on_touch_player,offset)
	var tween = create_tween()
	tween.tween_property(self,"radius",8,0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free)


func on_touch_player(body):
	if body is Enemy and not hostile:
		(body as Enemy).hurt(damage)

func _process(delta: float) -> void:
	super._process(delta)
	z_index = Main.Depths.Level
	for en in get_overlapping_areas():
		if en is Enemy:
			en.hurt(damage)

func _draw() -> void:
	draw_circle(offset,radius,Main.colors[1])
