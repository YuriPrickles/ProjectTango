class_name Gastropoke
extends Enemy
var snail_speed = 25
var current_agent_position: Vector2
var next_path_position: Vector2
var kb_dir:Vector2
var chasing = false
var spr_dict:Dictionary={
	36:Vector2(0,0),
	37:Vector2(1,0),
	52:Vector2(0,1),
	53:Vector2(1,1)
}
var facing = Vector2(0,0)
func _init(pos) -> void:
	super._init(pos,Rect2(-12,-4,12,4))
	offset = Vector2(-8,-14)
	navigator = NavigationAgent2D.new()
	navigator.radius = 64
	#navigator.debug_enabled = true
	navigator.avoidance_enabled = true
	navigator.path_desired_distance = 4.0
	navigator.target_desired_distance = 0.0
	add_child(navigator)
	var detection_range:Area2D = Area2D.new()
	Utils.attach_round_collision_shape(detection_range,32,on_detect,Vector2(-2,0))
	
	var leave_range:Area2D = Area2D.new()
	Utils.attach_round_collision_shape(leave_range,128,null,Vector2(-2,0))
	leave_range.connect("body_exited",leave_detect)
	
	add_child(detection_range)
	add_child(leave_range)
	
func _process(delta: float) -> void:
	super._process(delta)
	var plr:Player = Main.main.get_player()
	if plr and plr.position.distance_to(position) < 128:
		set_movement_target(plr.position)
		kb_dir = position.direction_to(plr.position)
func _physics_process(delta):
	if navigator.is_navigation_finished():
		return

	current_agent_position = position
	next_path_position = navigator.get_next_path_position()
	var final_vel = current_agent_position.direction_to(next_path_position)
	if abs(final_vel.x) > abs(final_vel.y) and facing != Vector2(1,0) * sign(final_vel.x):
		facing = Vector2(1,0) * sign(final_vel.x)
		queue_redraw()
	if abs(final_vel.x) <= abs(final_vel.y) and facing != Vector2(0,1) * sign(final_vel.y):
		facing = Vector2(0,1) * sign(final_vel.y)
		queue_redraw()
	if chasing:
		position += delta * final_vel * snail_speed

func on_touch_player(body):
	if body is Player:
		body.knockback(kb_dir, 200)
		body.hurt(2)
func on_detect(body: Node2D) -> void:
	if body is Player:
		chasing = true
		#if body.sneaking and body.direction != Vector2.ZERO: return
		queue_redraw()
func leave_detect(body: Node2D) -> void:
	if body is Player:
		chasing = false
		queue_redraw()
func _draw() -> void:
	var spr_index_offset = 0
	match facing:
		Vector2.LEFT:
			spr_index_offset = 0
		Vector2.DOWN:
			spr_index_offset = 2
		Vector2.RIGHT:
			spr_index_offset = 4
		Vector2.UP:
			spr_index_offset = 6
	for index in spr_dict.keys():
		Main.spr(Main.GameAtlas,self,(Vector2(-8,-14)) + (spr_dict.get(index)) * (Main.SPR_SIZE),spr_index_offset + index)
	if chasing:
		Main.draw_text_centered(self,"!", Vector2(0,-20),Main.colors[8])
