extends Entity
class_name Pickup

var item:Item
var locked_in:bool=false
var speed = 8
var always_follow:bool = false
var thrown = false
var draw_offset = Vector2(0,0)
var vel = Vector2.ZERO
var target_destination:Vector2
var starting_point:Vector2
var is_custom_pickup:bool = false
var landed:bool = false
static func new_pickup(item_scr:GDScript, pos:Vector2, alwaysfollow=false, throw:Vector2=Vector2(0,0)) -> Pickup:
	var i:Item = item_scr.new()
	if i.custom_pickup != null:
		return i.custom_pickup.new(item_scr,pos,alwaysfollow,throw)
	else:
		return new(item_scr,pos,alwaysfollow,throw)
func _init(item_scr:GDScript, pos:Vector2, alwaysfollow=false, throw:Vector2=Vector2(0,0)) -> void:
	item = item_scr.new()
	starting_point = pos
	y_sort_offset = -4
	var plr:Player = Main.main.get_player()
	thrown = throw != Vector2.ZERO
	always_follow = alwaysfollow
	Utils.attach_collision_shape(self, Rect2(0,0,4,4), _on_body_entered,null)
	position = pos
	draw_offset = Vector2.ZERO
	if thrown:
		target_destination = throw + Vector2(-4,-4)
		item.has_picked_up_before = true
		vel = plr.facing
		draw_offset = Vector2(0,-4)
func _ready() -> void:
	pass
var arc:float = 0.016
var arc_mult = 1
var arc_height = 48
func _process(delta: float) -> void:
	var plr:Player = Main.main.get_player()
	if thrown and position.distance_to(target_destination) >= 1:
		arc += delta * arc_mult
		speed = 160 * arc_mult
		draw_offset.y = -sin(position.distance_to(starting_point) * PI / starting_point.distance_to(target_destination)) * arc * arc_height - 2
		position = position.move_toward(target_destination,delta * speed)
		queue_redraw()
	else:
		if not landed:
			landed = true
			on_land()
		draw_offset.y = 0
		thrown = false
		vel = Vector2.ZERO
		if Main.main.resources.is_inventory_full():
			speed = 0
			locked_in = false
			return
		if (plr.Center.distance_to(position) <= 16 or locked_in) and (not Main.main.resources.is_inventory_full() or always_follow):
			locked_in = true
			position += position.direction_to(plr.Center) * delta * speed
			speed = min(128,speed + 2)
		if plr.Center.distance_to(position) <= 4:
			pickup()
		queue_redraw()
	super._process(delta)


var index = 16
func _draw() -> void:
	draw_ellipse(Vector2(4,8),4,2,Main.colors[0] * 0.4)
	Main.spr(Main.ItemAtlas,self,draw_offset,item.spr_index)

func pickup():
	item.on_pickup()
	queue_free()
	pass

func on_land():
	pass

func _on_body_entered(body: Node2D) -> void:
	if not Main.main.resources.is_inventory_full() and not thrown:
		pickup()
