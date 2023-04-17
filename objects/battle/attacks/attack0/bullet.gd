extends Area2D

var acceleration := 0.0
var velocity := Vector2.ZERO
var player:Node2D = null
var radius := 0

func init(ori:Vector2, accel:float, plr:Node2D, r:int):
	acceleration = accel
	player = plr
	position = ori
	radius = r*r

func touch_player():
	pass
	#queue_free()

func _process(delta):
	velocity.y += acceleration
	position += velocity
	var dist = position.distance_squared_to(player.position)
	if dist < radius:
		var sig = sign(position.x - player.position.x)
		var dist_y = abs(player.position.y - position.y)
		var pos_x = sqrt(radius - dist_y*dist_y)
		position.x = player.position.x + sig * pos_x
		

func _on_Timer_timeout():
	queue_free()

