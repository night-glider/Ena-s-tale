extends Area2D

var stage = 0
var spawn_pos:Vector2
var end_pos:Vector2
var fly_pos:Vector2
var n_spd = 0
var radius = 0
var fly_spd = 0

var n = 0

func init(spawn:Vector2, end:Vector2, nspd:float, r:float, fly:Vector2, flyspd:float):
	spawn_pos = spawn
	end_pos = end
	n_spd = nspd
	radius = r
	fly_pos = fly
	fly_spd = flyspd

func touch_player():
	queue_free()

func _process(delta):
	if stage == 0:
		position.y = lerp(spawn_pos.y, end_pos.y, n)
		var pos = lerp(spawn_pos.x, end_pos.x, n)
		position.x = pos + (sin(n*PI)*radius)
		
		n += n_spd
		
		if n > 1:
			n = 0
			stage = 1
	
	if stage == 1:
		position = lerp(end_pos, fly_pos, n)
		n += n_spd
		
		if n > 1:
			stage = 2
	
	if stage == 2:
		position.y -= fly_spd
	

func _on_Timer_timeout():
	queue_free()

