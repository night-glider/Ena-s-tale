extends Area2D

var angle = 0.1
var damp = 0.99
var spd = 5

var velocity:Vector2

func _ready():
	velocity = Vector2(spd,0).rotated( rand_range(-angle,angle) )

func touch_player():
	queue_free()

func _process(delta):
	position+=velocity
	velocity*=damp

func _on_Timer_timeout():
	queue_free()

