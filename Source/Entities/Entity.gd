class_name Entity
extends Area2D

var width: float
var height: float
var offset: Vector2:
	get: return Vector2(width,height)
	set(value): offset = value
var Center:
	get: return position + (Vector2(width,height) / 2)
var int_position: Vector2i:
	get: return Vector2i(position)
