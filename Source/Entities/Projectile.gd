class_name Projectile
extends Entity

var proj_owner:Entity
var hostile:bool = true
var projectile_id:int
var damage = 0
var hits = 1
var velocity:Vector2
var lifetime:float = 1
var max_lifetime:float
func _init(p_owner,pos,collision:Rect2,id:int,_velocity:Vector2,_hostile:bool,_damage:int,_hits:int,_lifetime:float) -> void:
	projectile_id = id
	velocity = _velocity
	hostile = _hostile
	hits = _hits
	damage = _damage
	proj_owner = p_owner
	dmg_source_name = proj_owner.dmg_source_name
	lifetime = _lifetime
	max_lifetime = lifetime
	Utils.attach_collision_shape(self,collision,on_touch_player,on_untouch_player)
	position = pos
	offset = collision.size
	queue_redraw()

func clear_collisions():
	disconnect("body_entered",on_touch_player)
	disconnect("body_exited",on_untouch_player)
	for col in get_children():
		if col is CollisionShape2D:
			col.queue_free()

##Projectile hostility is not specified here.
static func new_projectile(p_owner:Entity,id:int,_position:Vector2,_velocity:Vector2,_damage:int) -> Projectile:
	var created_proj:Projectile = null
	match id:
		ProjectileID.BerrySeed: created_proj = BerrySeed.new(p_owner,id,_position,_velocity,_damage)
		ProjectileID.SquallitaShockwave: created_proj = SquallitaShockwave.new(p_owner,id,_position,_velocity,_damage)

	Main.main.get_level().projectiles.add_child(created_proj)
	return created_proj
func _process(delta: float) -> void:
	super._process(delta)
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	movement()
	queue_redraw()
func movement():
	position += velocity
##Override this function for behavior when the player collides with the projectile.
func on_touch_player(body):
	if body is TileMapLayer and lifetime < max_lifetime * 0.8:
		queue_free()
	if not hostile and body is Enemy:
		body.hurt(damage)
	if hostile and body is Player:
		body.hurt(damage,proj_owner)
		hits -= 1
	if hits <= 0:
		queue_free()
func on_untouch_player(body):
	pass
