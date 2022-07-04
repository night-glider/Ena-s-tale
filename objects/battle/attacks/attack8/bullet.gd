extends Area2D

var spd_y = 0

func init(spd:float):
	spd_y = spd

func touch_player():
	queue_free()

func _process(delta):
	position.y += spd_y

func _on_Timer_timeout():
	queue_free()

