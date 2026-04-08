class_name Interactable
extends Entity

var touching = false

func _init(pos:Vector2,collider:Rect2) -> void:
	super._init(pos,collider)

func on_touch_player(body):
	if body is Player:
		body.might_interact = true
		touching = true
		queue_redraw()
func on_untouch_player(body):
	if body is Player:
		body.might_interact = false
		touching = false
		queue_redraw()
