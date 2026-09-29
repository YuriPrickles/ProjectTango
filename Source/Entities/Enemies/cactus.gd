class_name Cactus
extends Trap
func _init(pos) -> void:
	name_file = "res://Source/Names/cactus.txt"
	super._init(pos, Rect2(4,6,6,4))
	draw_offset = Vector2(0,0)
	var detection_range:Area2D = Area2D.new()
	Utils.attach_round_collision_shape(detection_range,16,on_detect,Vector2(0,0))
	detection_range.connect("body_exited",leave_detect)
	add_child(detection_range)

func _process(delta: float) -> void:
	super._process(delta)

func _draw() -> void:
	super()
	Main.spr(Main.GameAtlas,self,Vector2.ZERO,181)



func on_detect(body: Node2D) -> void:
	if body is Player:
		if body.sneaking and body.direction != Vector2.ZERO: return
		trigger_trap(body)

func trigger_trap(plr:Player) -> TriggerTrapEvent:
	var trtevent = super.trigger_trap(plr)
	if not trtevent.trigger_success:
		return null
	queue_redraw()
	return trtevent


func leave_detect(body: Node2D) -> void:
	pass


func on_touch_thing(body):
	if body is Player:
		body.hurt(10,self)
