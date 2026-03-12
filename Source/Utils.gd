class_name Utils
extends Node

##Quickly add a Rectangle collider to a collidable 2D object.
static func attach_collision_shape(thing:CollisionObject2D,size:Rect2,on_touch:Callable,on_untouch):
	if thing is Pickup:
		thing.set_collision_layer_value(3,true)
		thing.set_collision_mask_value(1,true)
	if thing is Trap:
		thing.set_collision_layer_value(4,true)
		thing.set_collision_mask_value(1,true)
	if thing is Enemy:
		thing.set_collision_layer_value(5,true)
		thing.set_collision_mask_value(1,true)
	var colmask = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = size.size
	colmask.position = size.size + size.position
	colmask.shape = shape
	if thing is Area2D:
		thing.connect("body_entered",on_touch)
		if on_untouch != null:
			thing.connect("body_exited",on_untouch)
	thing.add_child(colmask.duplicate())

##Quickly add a Circle collider to a collidable 2D object.
static func attach_round_collision_shape(thing:CollisionObject2D,radius:float,on_touch,extra_offset:Vector2 = Vector2.ZERO):
	if thing is Pickup:
		thing.set_collision_layer_value(3,true)
		thing.set_collision_mask_value(1,true)
	if thing is Trap:
		thing.set_collision_layer_value(4,true)
		thing.set_collision_mask_value(1,true)
	var colmask = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	colmask.position = extra_offset
	colmask.shape = shape
	if on_touch:
		thing.connect("body_entered",on_touch)
	thing.add_child(colmask.duplicate())
