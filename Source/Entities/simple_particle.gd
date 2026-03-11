class_name SimpleParticle

var position:Vector2
var velocity:Vector2
var lifetime:float
var color:Color
var end_color:Color

func _init(pos,vel,time,col,ecol=null) -> void:
	position = pos
	velocity = vel
	lifetime =time
	color = col
	end_color = col if not ecol else ecol
