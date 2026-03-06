extends Area2D
class_name Pickup

var item:Item
var locked_in:bool=false
var speed = 8
var always_follow:bool = false
var thrown = false
var draw_offset = Vector2(0,0)
var vel = Vector2.ZERO

func _init(id:int, pos:Vector2, alwaysfollow=false, throw:bool=false) -> void:
	var plr:Player = Main.main.get_player()
	thrown = throw
	item = Item.new_item(id)
	always_follow = alwaysfollow
	var area = Area2D.new()
	area.set_collision_layer_value(3,true)
	area.set_collision_mask_value(1,true)
	var colmask = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(4,4)
	colmask.shape = shape
	area.connect("body_entered",_on_body_entered)
	area.position = Vector2(4,4)
	area.add_child(colmask)
	add_child(area)
	position = pos
	draw_offset = Vector2.ZERO
	if thrown:
		print("Thrown: " + item.item_name)
		vel = plr.facing
		draw_offset = Vector2(0,-4)
func _ready() -> void:
	pass

var reached_peak = false
func _process(delta: float) -> void:
	var plr:Player = Main.main.get_player()
	if draw_offset.length() != 0:
		if draw_offset.y <= -16:
			reached_peak = true
		if draw_offset.y > -16 and draw_offset.y <= -4 and not reached_peak:
			draw_offset.y = clamp(draw_offset.y - 1.25, -16, -4)
		else:
			draw_offset.y = clamp(draw_offset.y + 1.5, -16, 0)
		speed = 80
		position += vel * delta * speed
		queue_redraw()
	else:
		thrown = false
		vel = Vector2.ZERO
		if Main.main.resources.is_inventory_full():
			speed = 0
			locked_in = false
			return
		if (plr.position.distance_to(position) <= 16 or locked_in) and (not Main.main.resources.is_inventory_full() or always_follow):
			locked_in = true
			position += position.direction_to(plr.position - plr.size/2) * delta * speed
			speed = min(128,speed + 2)


func _draw() -> void:
	Main.main.spr(get_canvas_item(),draw_offset,item.spr_index)

func pickup():
	item.on_pickup()
	queue_free()
	pass


func _on_body_entered(body: Node2D) -> void:
	if not Main.main.resources.is_inventory_full() and not thrown:
		pickup()
