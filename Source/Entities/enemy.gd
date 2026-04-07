class_name Enemy
extends Entity

var Health:int
var MaxHealth:int
const IFRAMES = 0.2
var iframe_timer:float = 0
var peril_penalty = 5
var navigator:NavigationAgent2D
func set_movement_target(movement_target: Vector2):
	navigator.target_position = movement_target
##For collision, the Rect2's x and y represent offset, while the size is the size.
func _init(pos,collision:Rect2) -> void:
	super._init(pos,collision)

	
func _ready() -> void:
	pass

func hurt(value:int):
	if iframe_timer > 0 or value == 0: return
	iframe_timer = IFRAMES
	print("%s hurt for %s damage" % [dmg_source_name,value])
	Health -= value
	if Health <= 0:
		vanquish()

func vanquish():
	Main.main.add_peril(peril_penalty)
	queue_free()

func _process(delta: float) -> void:
	modulate = Main.colors[7] if floori(iframe_timer * 100.0) % 4 == 0 and iframe_timer < IFRAMES else Main.colors[8]
	if iframe_timer > 0:
		iframe_timer = clampf(iframe_timer - delta,0,IFRAMES)
	super._process(delta)



func _draw() -> void:
	pass
