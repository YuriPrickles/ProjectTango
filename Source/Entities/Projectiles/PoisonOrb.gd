class_name PoisonOrb
extends Projectile

var radius = 0
func _init(p_owner:Entity,pos:Vector2,_velocity:Vector2,_damage:int) -> void:
	super._init(p_owner,pos, Rect2(0,0,16,16),_velocity,true,_damage,1,12)
	hostile = true
	clear_collisions()
	Utils.attach_round_collision_shape(self,radius,on_touch_thing,offset)
	var tween = create_tween()
	tween.tween_property(self,"radius",12,4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(kill_me)

func _process(delta: float) -> void:
	if dying: velocity *= 0.6
	super(delta)
	clear_collisions()
	Utils.attach_round_collision_shape(self,radius,on_touch_thing,offset)

var dying = false
func kill_me():
	dying =true
	await get_tree().create_timer(1).timeout
	queue_free()
func handle_wall_col():
	pass

func _draw() -> void:
	draw_circle(offset,radius,Main.colors[Utils.blink(10,3,12)])
	draw_circle(offset,radius - 3,Main.colors[11])
