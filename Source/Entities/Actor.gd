class_name Actor
extends CharacterBody2D

var width: float
var height: float
var size:
	get: return Vector2(width,height)
var Center:
	get: return position + (Vector2(width,height) / 2)
