class_name SquallitaPickup
extends Pickup

var return_timer:Timer = Timer.new()

func _init(item_scr:GDScript, pos:Vector2, alwaysfollow=false, throw:Vector2=Vector2(0,0)) -> void:
	super._init(item_scr,pos,alwaysfollow,throw)
	arc_height = 180
	arc_mult = 0.2

func _process(delta: float) -> void:
	z_index = Main.Depths.Player
	super._process(delta)

func on_land():
	add_child(return_timer)
	return_timer.start(5)
	return_timer.timeout.connect(start_returning)
	return_timer.one_shot = true
	var plr = Main.main.get_player()
	SquallitaShockwave.new(self,position,Vector2.ZERO,plr.get_damage(4))

func start_returning():
	locked_in = true
	always_follow = true
	speed = 190
	return_timer.queue_free()

func _draw() -> void:
	if Engine.get_frames_drawn() % 8 == 0:
		if draw_offset.y != 0:
			index = (index + 1)
			if index > 19:
				index = 16
		else:
			index = 78 if index != 78 else 79
	Main.spr(Main.GameAtlas,self,draw_offset, index)
