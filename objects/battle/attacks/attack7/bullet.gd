extends Area2D

var stage:float = 0
var spawn_point:Vector2
var end_point:Vector2
var n:float = 0

func init(spawn:Vector2, end:Vector2):
	spawn_point = spawn
	end_point = end

func touch_player():
	queue_free()

func _process(delta):
	if stage == 0:
		position.x = spawn_point.x + rand_range(-5,5)
		position.y = spawn_point.y + rand_range(-5,5)
	if stage == 1:
		position = lerp(spawn_point, end_point, n)
		n+=0.01
		
		if n > 1:
			stage = 2
	if stage == 2:
		position.y += 2

func _on_Timer_timeout():
	stage = 1

