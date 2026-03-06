extends Area2D
class_name Pickup

var item:Item = Item.new_item(ItemID.Metal)
var locked_in:bool=false
var speed = 8
var always_follow:bool = false

func _init(id, pos, alwaysfollow=false) -> void:
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
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var plr:Player = Main.main.get_player()
	if Main.main.resources.is_inventory_full():
		speed = 0
		locked_in = false
		return
	if(not Main.main.resources.is_inventory_full() or always_follow) and (plr.position.distance_to(position) <= 16 or locked_in):
		locked_in = true
		position += position.direction_to(plr.position - plr.size/2) * delta * speed
		speed = min(128,speed + 2)


func _draw() -> void:
	Main.main.spr(get_canvas_item(),Vector2(0,0),item.spr_index)

func pickup():
	item.on_pickup()
	queue_free()
	pass


func _on_body_entered(body: Node2D) -> void:
	if not Main.main.resources.is_inventory_full():
		print("response")
		pickup()
