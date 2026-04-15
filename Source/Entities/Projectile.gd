class_name Projectile
extends Entity

var proj_owner:Entity
var hostile:bool = true
var damage:int:
	get: return damage
var hits:
	set(value):
		hits = value
		handle_hitcount()
var velocity:Vector2
var lifetime:float = 1
var max_lifetime:float
var lifetime_percent:float:
	get: return lifetime/max_lifetime
var starting_pos:Vector2
var ending_pos:Vector2

var damage_mult:float
signal add_to_damage_mult(value:float)
func _init(p_owner,pos,collision:Rect2,_velocity:Vector2,_hostile:bool,_damage:int,_hits:int,_lifetime:float) -> void:
	starting_pos = pos
	velocity = _velocity
	hostile = _hostile
	hits = _hits
	damage = _damage
	proj_owner = p_owner
	dmg_source_name = proj_owner.dmg_source_name if proj_owner else "Ownerless"
	lifetime = _lifetime
	max_lifetime = lifetime
	Utils.attach_collision_shape(self,collision,on_touch_thing,on_untouch_thing)
	position = pos
	offset = collision.size
	if Main.main.get_level():
		Main.main.get_level().projectiles.add_child(self)
	queue_redraw()

func clear_collisions():
	disconnect("body_entered",on_touch_thing)
	disconnect("body_exited",on_untouch_thing)
	disconnect("area_entered",on_touch_thing)
	disconnect("area_exited",on_untouch_thing)
	for col in get_children():
		if col is CollisionShape2D:
			col.queue_free()

func get_final_damage(base_damage:int):
	return base_damage * damage_mult

func _process(delta: float) -> void:
	super._process(delta)
	lifetime -= delta
	handle_lifetime()
	movement()
	queue_redraw()

func handle_lifetime():
	if lifetime <= 0:
		queue_free()
func handle_hitcount():
	if hits == 0:
		queue_free()
func handle_wall_col():
	queue_free()
func handle_enemy_col():
	hits -= 1
	pass
func handle_player_col():
	pass

func movement():
	position += velocity
##Override this function for behavior when the player collides with the projectile.


func on_touch_thing(body):
	ending_pos = position
	if body is TileMapLayer:
		handle_wall_col()
	if not hostile and body is Enemy:
		handle_enemy_col()
		body.hurt(damage,self)
		handle_hitcount()
	if hostile and body is Player:
		handle_player_col()
		if proj_owner:
			body.hurt(damage,proj_owner)
		else:
			body.hurt_hurter_freed(damage,dmg_source_name)
		handle_hitcount()
func on_untouch_thing(body):
	pass
