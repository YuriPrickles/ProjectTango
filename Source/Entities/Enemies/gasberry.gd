class_name Gasberry
extends Enemy


var ripe: bool:
	get: return ripe
	set(value): queue_redraw(); ripe = value
var shoot_delay = 1.4
const DELAY_VALUE = 1.4
var room_assigned:int
var poison_delay = 1.5
const POISON_VALUE = 1.5
const POISON_TICK_VALUE = 0.7

func _init(pos,room_ass) -> void:
	name_file = "res://Source/Names/gasberry.txt"
	super._init(pos,Rect2(-2,-2,6,4))
	spr_dict={
		44:Vector2(0,-1),
		60:Vector2(0,0)
	}
	Health = 40
	MaxHealth = 40
	room_assigned = room_ass
	peril_penalty = 8
	peril_affection_thresholds.append(randi_range(20,80))

func _process(delta: float) -> void:
	super._process(delta)
	if not ripe and Main.main.get_peril() >= peril_affection_thresholds[0]:
		ripe = true
	var plr:Player = Main.main.get_player()
	if plr.position.distance_to(position) <= 320:
		queue_redraw()
	if Main.main.get_current_room() == room_assigned:
		if not ripe:
			shoot_delay -= delta
			if shoot_delay <= 0:
				shoot_seed(plr.position)
				shoot_delay = DELAY_VALUE - float(Main.main.get_peril()) / Main.MAX_PRL
		else:
			poison_delay -= delta
			if poison_delay <= 0:
				plr.hurt(1,self)
				poison_delay = POISON_TICK_VALUE
			
	else:
		shoot_delay = DELAY_VALUE
		poison_delay = POISON_VALUE
func on_touch_player(body):
	if body is TileMapLayer:
		position += position.direction_to(Main.main.get_level().dungeon_layout.rooms[room_assigned].get_center())
func shoot_seed(target:Vector2):
	var origin:Vector2 = position + Vector2(2,-8)
	Projectile.new_projectile(self,0,origin,origin.direction_to(target) * 0.3,10)
	
func _draw() -> void:
	var lvl:Level = Main.main.get_level()
	var proper_room:Branch = lvl.dungeon_layout.rooms[room_assigned]
	#if peril_affection_thresholds[0]:
		#Main.draw_text( str(peril_affection_thresholds[0]),Vector2(0,8))
	if ripe:
		draw_rect(Rect2(Vector2i(0,-7) - Vector2i(position) + (proper_room.position * 8),proper_room.size * 8),Main.colors[11] * max(0.2,abs(1-(poison_delay/POISON_VALUE))),true,-1,true)
	draw_from_dict(spr_dict,Vector2(0,-4),0 if not ripe else 1)

func draw_from_dict(_spr_dict:Dictionary[int, Vector2], draw_offset:Vector2, spr_index_offset:int):
	for index in _spr_dict.keys():
		var wiggle_offset:Vector2 = Vector2(sin(Engine.get_process_frames() * clamp((shoot_delay/DELAY_VALUE) * 0.5,0,0.2)) * 1, 0)
		Main.spr(Main.GameAtlas,self,(draw_offset if index == 60 else draw_offset + wiggle_offset) + (_spr_dict.get(index)) * (Main.SPR_SIZE),(spr_index_offset if index == 44 else 0) + index)
