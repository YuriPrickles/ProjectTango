class_name Bullet
extends Projectile

var color:Color = Main.colors[10]

func _init(p_owner:Entity,pos:Vector2,_velocity:Vector2,_damage:int) -> void:
	super._init(p_owner,pos, Rect2(0,0,2,2),_velocity,false,_damage,1,10)
	draw_offset = Vector2(0,0)

func _draw() -> void:
	super()
	draw_circle(offset - (velocity * 1),1,color)
	draw_circle(offset,1,color)
