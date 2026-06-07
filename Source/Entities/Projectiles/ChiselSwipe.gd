class_name ChiselSwipe
extends Projectile
var radius:float = 0
var use_dir:Vector2
var combo
func _init(p_owner:Entity,pos:Vector2,_velocity:Vector2,_damage:int,ud:Vector2,c:int) -> void:
	use_dir=ud
	super._init(p_owner,pos,Rect2(use_dir.x * 4,use_dir.y * 4,20,20),_velocity,false,_damage,-1,9)
	z_index = 6
	combo = c
	dont_hit=[]
	hostile = false
	var tween = create_tween()
	tween.tween_property(self,"radius",8,0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(queue_free)

func handle_wall_col():
	pass

var dont_hit:Array[Enemy]
func _process(delta: float) -> void:
	super._process(delta)
	var plr := Main.main.get_player()
	position = plr.position + (use_dir * 2)
	var has_bounced:bool = false
	for en in get_overlapping_areas():
		if en is Enemy and not dont_hit.has(en):
			if not has_bounced:
				plr.knockback(-use_dir,70 if combo < 2 else 140)
			has_bounced = true
			dont_hit.append(en)
			en.hurt(damage,self)

func _draw() -> void:
	var point1 = use_dir.rotated(deg_to_rad(90)) * 1
	var point2 = use_dir.rotated(deg_to_rad(-90)) * 1
	var start_angle : float = (point2 - point1).angle()
	var end_angle : float = (point1 - point2).angle() #lerpf(start_angle, (point1 - point2).angle(), radius / 8)
	
	print(start_angle, "  ", end_angle)
	if end_angle <= 0: end_angle += TAU
	var ellipse_size = Vector2(8,8)
	ellipse_size.x += 4 if sign(use_dir.x) == 0 else 2
	ellipse_size.y += 4 if sign(use_dir.y) == 0 else 2
	var final_start_angle:Array[float] = [start_angle, lerpf(end_angle, start_angle, radius / 8), lerpf(start_angle, end_angle, radius / 8)  ]
	var final_end_angle:Array[float] = [lerpf(start_angle, end_angle, radius / 8), end_angle, lerpf(end_angle, start_angle, radius / 8)]
	
	for i in [1.0,0.75,0.5,0.25]:
		#draw_arc(Vector2.ZERO, 8 * i, start_angle, end_angle, 8, Main.colors[7],2)
		draw_ellipse_arc(Vector2.ZERO,ellipse_size.x * i,ellipse_size.y * i,final_start_angle[combo],final_end_angle[combo],12,Main.colors[8],2)
