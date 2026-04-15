class_name BerrySeed
extends Projectile

func _init(p_owner:Entity,pos:Vector2,_velocity:Vector2,_damage:int) -> void:
	super._init(p_owner,pos, Rect2(0,0,2,2),_velocity,true,_damage,1,3)
	hostile = true

func handle_wall_col():
	if lifetime < max_lifetime * 0.8:
		queue_free()
func _draw() -> void:
	draw_circle(offset,2,Main.colors[11])
	draw_circle(offset,2,Main.colors[3],false)
