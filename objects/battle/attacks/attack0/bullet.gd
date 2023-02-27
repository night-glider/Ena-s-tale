extends Area2D

var origin = Vector2.ZERO
var target = Vector2.ZERO
var speed = 0
var radius = 0

func init(ori:Vector2, tar:Vector2, spd:float, rad:float):
	origin = ori
	target = tar
	speed = spd
	radius = rad
	
	position = ori

func touch_player():
	pass
	#queue_free()

func _process(delta):
	origin = origin.move_toward(target, speed)
	position.x = origin.x + rand_range(-radius, radius)
	position.y = origin.y + rand_range(-radius, radius)

func _on_Timer_timeout():
	queue_free()

