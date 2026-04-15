class_name HomingBolt
extends Projectile

var color:Color = Main.colors[12]

func _init(p_owner:Entity,pos:Vector2,_velocity:Vector2,_damage:int) -> void:
	super._init(p_owner,pos, Rect2(0,0,6,6),_velocity,false,_damage,1,20)

var enemy:Enemy = null
func _process(delta: float) -> void:
	var saved_distance = 30
	for en:Enemy in Main.main.get_level().get_enemies():
		if en and en.position.distance_to(position) < saved_distance:
			
			saved_distance = en.position.distance_to(position)
			enemy = en
	if enemy:
		velocity = position.direction_to(enemy.position - Vector2(3,3)) * 0.3
	super._process(delta)

func _draw() -> void:
	draw_circle(offset - (velocity * 1),3,Main.colors[Utils.blink(12,7,6)])
	draw_circle(offset,3,Main.colors[Utils.blink(12,7,6)])
