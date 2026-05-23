class_name Enemy
extends Entity

var Health:int
var MaxHealth:int
const IFRAMES = 0.2
var iframe_timer:float = 0
var peril_penalty = 5
var navigator:NavigationAgent2D

var positive_speed_mod = 0
var negative_speed_mod = 0
var final_speed_mod = 1
var effects:Array[Effect]
var damage_flash_self_only:bool = false

func set_movement_target(movement_target: Vector2):
	navigator.target_position = movement_target
##For collision, the Rect2's x and y represent offset, while the size is the size.
func _init(pos,collision:Rect2) -> void:
	super._init(pos,collision)

	
func _ready() -> void:
	pass

func hurt(value:int,source):
	if iframe_timer > 0 or value == 0: return
	var devent = DamageEvent.new(value,self,source)
	iframe_timer = IFRAMES
	print("%s hurt for %s damage" % [dmg_source_name,devent.damage])
	Health -= devent.damage
	if Health <= 0:
		vanquish()

var stunned:bool:
	get: return stun_time > 0
var stun_time:float=0

func vanquish():
	Main.main.add_peril(peril_penalty)
	queue_free()

func _process(delta: float) -> void:
	if damage_flash_self_only:
		self_modulate = Main.colors[7] if floori(iframe_timer * 100.0) % 4 == 0 and iframe_timer < IFRAMES else Main.colors[8]
	else:
		modulate = Main.colors[7] if floori(iframe_timer * 100.0) % 4 == 0 and iframe_timer < IFRAMES else Main.colors[8]
	if iframe_timer > 0:
		iframe_timer = clampf(iframe_timer - delta,0,IFRAMES)
	negative_speed_mod = 0
	positive_speed_mod = 0
	var mevent:MoveEvent = MoveEvent.new(0,self)
	if mevent.speedmod < 0:
		if abs(mevent.speedmod) > negative_speed_mod:
			negative_speed_mod = abs(mevent.speedmod)
	else:
		if abs(mevent.speedmod) > positive_speed_mod:
			positive_speed_mod = abs(mevent.speedmod)
	final_speed_mod = 1 + (positive_speed_mod - negative_speed_mod)
	super._process(delta)



func _draw() -> void:
	pass
