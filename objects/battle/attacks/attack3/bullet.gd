extends Area2D

var velocity = Vector2.ZERO
var destroy_y = 99999


func init(vel:Vector2, y:int):
	velocity = vel
	destroy_y = y

func touch_player():
	queue_free()

func _process(delta):
	position+=velocity
	if position.y > destroy_y:
		queue_free()

func _on_Timer_timeout():
	queue_free()

