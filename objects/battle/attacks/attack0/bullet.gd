extends Area2D



func touch_player():
	queue_free()

func _process(delta):
	pass

func _on_Timer_timeout():
	queue_free()

