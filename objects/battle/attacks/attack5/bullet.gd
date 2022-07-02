extends Area2D

var velocity:float
var acceleration:float

func init(spd:float, accel:float):
	velocity = spd
	acceleration = accel

func touch_player():
	queue_free()

func _process(delta):
	position.y += velocity
	velocity+=acceleration

func _on_Timer_timeout():
	queue_free()

