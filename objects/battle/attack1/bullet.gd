extends Area2D

var velocity:Vector2

func _ready():
	velocity = Vector2(5,0).rotated( rand_range(-0.1,0.1) )

func touch_player():
	queue_free()

func _process(delta):
	position+=velocity
	velocity*=0.99

func _on_Timer_timeout():
	queue_free()

