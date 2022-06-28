extends Node2D

func init(pos:Vector2, size:Vector2, time:float):
	position = pos
	$ColorRect.margin_left = -size.x/2
	$ColorRect.margin_right = -$ColorRect.margin_left
	$ColorRect.margin_bottom = size.y/2
	$ColorRect.margin_top = -$ColorRect.margin_bottom

	$destruction.start(time)



func _on_Timer_timeout():
	if modulate.a == 1:
		modulate.a = 0.2
	else:
		modulate.a = 1


func _on_destruction_timeout():
	queue_free()
