class_name Waffle
extends Projectile

var trails:Array
var come_back = false
var chase_player = false
func _init(p_owner:Entity,pos:Vector2,_velocity:Vector2,_damage:int) -> void:
	super._init(null,pos, Rect2(0,0,8,8),_velocity,false,_damage,3,0.3)
	velocity = velocity.rotated(deg_to_rad(15))

var target
func _process(delta: float) -> void:
	var plr  = Main.main.get_player()
	target = plr.Center - plr.size/2
	if come_back and Center.distance_to(starting_pos) < 24:
		chase_player = true
	elif not chase_player:
		velocity = velocity.rotated(deg_to_rad(-1))
	if chase_player:
		var tween = create_tween()
		tween.tween_property(self,"velocity",position.direction_to(target) * 2,0.2)
		if plr.Center.distance_to(Center) < 6:
			queue_free()
	else:
		velocity = velocity.rotated(deg_to_rad(-1))
	super._process(delta)

func handle_lifetime():
	if lifetime <= -5:
		queue_free()
	if lifetime <= 0 and not come_back:
		come_back = true
		var tween = create_tween()
		tween.tween_property(self,"velocity",position.direction_to(target) * 2,0.2)
func bounce():
	if lifetime < 0.285 and not chase_player:
		velocity *= -1
func handle_wall_col():
	bounce()
func handle_enemy_col():
	bounce()

func _draw() -> void:
	draw_circle(offset - (velocity * 1.5),3,Main.colors[4])
	draw_circle(offset - (velocity * 2),3,Main.colors[4])
	draw_circle(offset - (velocity * 2.5),2,Main.colors[15])
	draw_circle(offset,4,Main.colors[Utils.blink(9,4,10)])
	draw_circle(offset,3,Main.colors[Utils.blink(4,9,10)])
	draw_circle(offset,2,Main.colors[Utils.blink(9,4,10)])
