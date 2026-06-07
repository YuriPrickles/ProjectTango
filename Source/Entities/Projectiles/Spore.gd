class_name Spore
extends Projectile

var color:Color = Main.colors[2]

func _init(p_owner:Entity,pos:Vector2,_velocity:Vector2,_damage:int) -> void:
	iframes_on_hit = 0
	super._init(p_owner,pos, Rect2(0,0,3,3),_velocity,false,_damage,-1,4)

func handle_hitcount():
	pass

func _process(delta: float) -> void:
	velocity *= 0.8
	super._process(delta)

func _draw() -> void:
	draw_circle(offset - (velocity * 1),1,color)
	draw_circle(offset,1,color)
