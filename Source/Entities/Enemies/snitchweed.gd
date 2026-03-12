class_name Snitchweed
extends Trap
var asleep:bool = true
var force_awake:bool = false
func _init(pos) -> void:
	super._init(pos, Rect2(0,6,4,2))
	var detection_range:Area2D = Area2D.new()
	Utils.attach_round_collision_shape(detection_range,16,on_detect,Vector2(4,5))
	detection_range.connect("body_exited",leave_detect)
	add_child(detection_range)

func _process(delta: float) -> void:
	super._process(delta)
	

func _draw() -> void:
	Main.spr(Main.GameAtlas,self,offset,35 if asleep else 51)



func on_detect(body: Node2D) -> void:
	if body is Player and not force_awake:
		if body.sneaking and body.direction != Vector2.ZERO: return
		queue_redraw()
		wake_up_nearby()
		force_awake = true
		asleep = false

func wake_up_nearby():
	var lvl:Level = Main.main.get_level()
	Main.main.add_instability(1)
	for trap:Trap in lvl.traps.get_children():
		if trap != self and trap is Snitchweed and trap.int_position.distance_to(int_position) < 64:
			trap.force_awake = true
	for trap:Trap in lvl.traps.get_children():
		if trap == self or trap is Snitchweed and trap.int_position.distance_to(int_position) < 64:
			(trap as Snitchweed).awoken_coroutine(position)

##When awoken by another Snitchweed.
func awoken_coroutine(source_pos:Vector2):
	await get_tree().create_timer(0.1).timeout
	asleep = false
	queue_redraw()
	await get_tree().create_timer(45).timeout
	force_awake = false
	asleep = true	
	queue_redraw()

func leave_detect(body: Node2D) -> void:
	if body is Player and not force_awake:
		queue_redraw()
		asleep = true

func on_touch_player(body):
	if body is Player:
		print("touch")
		body.hurt(1 if not asleep else 0)
