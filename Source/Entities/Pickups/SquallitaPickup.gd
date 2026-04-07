class_name SquallitaPickup
extends Pickup

func _init(id:int, pos:Vector2, alwaysfollow=false, throw:Vector2=Vector2(0,0)) -> void:
	super._init(id,pos,alwaysfollow,throw)
	arc_height = 180
	arc_mult = 0.2

func _process(delta: float) -> void:
	z_index = Main.Depths.Player
	super._process(delta)

func on_land():
	var plr = Main.main.get_player()
	Projectile.new_projectile(self,ProjectileID.SquallitaShockwave,position,Vector2.ZERO,4)

func _draw() -> void:
	if Engine.get_frames_drawn() % 8 == 0:
		if draw_offset.y != 0:
			index = (index + 1)
			if index > 19:
				index = 16
		else:
			index = 78 if index != 78 else 79
	Main.spr(Main.GameAtlas,self,draw_offset, index)
