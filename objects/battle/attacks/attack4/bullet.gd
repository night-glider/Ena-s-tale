extends Area2D

var stage:int = 0
var current_pos:Vector2
var stage1_position:Vector2
var velocity:Vector2

func init(spawnpoint:Vector2, delay:float, stage1_pos):
	position = spawnpoint
	current_pos = spawnpoint
	$stage_timer.start(delay)
	stage1_position = stage1_pos

func touch_player():
	queue_free()

func _process(delta):
	match stage:
		0:
			position.x = current_pos.x + rand_range(-2,2)
			position.y = current_pos.y + rand_range(-2,2)
		1:
			position.x = lerp(position.x, stage1_position.x, 0.05)
			position.y = lerp(position.y, stage1_position.y, 0.05)
			if abs(position.x - stage1_position.x) < 1:
				stage = 2
		2:
			position.x = stage1_position.x + rand_range(-2,2)
			position.y = stage1_position.y + rand_range(-2,2)
		3:
			position += velocity


func stage3_start(delay:float, pos:Vector2, spd:float):
	$stage_timer.start(delay)
	velocity = position.direction_to(pos) * spd


func _on_stage_timer_timeout():
	if stage == 0:
		stage = 1
	if stage == 2:
		stage = 3
