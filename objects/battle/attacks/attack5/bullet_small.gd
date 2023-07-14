extends Area2D

var velocity:Vector2

func init(spd:float):
	velocity = Vector2.ONE.rotated(rand_range(-PI, PI)) * spd

func touch_player():
	queue_free()

func _process(delta):
	position += velocity

func _on_Timer_timeout():
	queue_free()

