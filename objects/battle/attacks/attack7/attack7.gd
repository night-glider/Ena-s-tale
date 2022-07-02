extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack7/bullet.tscn")

export var box_position := Vector2(252,221)
export var box_size := Vector2(136, 136)

export var export_attack_duration:float = 10



func _ready():
	$self_destruct.start(export_attack_duration)
	
	for i in 100:
		var new_bullet = bullet.instance()
		var spawn_point = Vector2(320,50)
		spawn_point.x += rand_range(-25,25)
		spawn_point.y += rand_range(-25,25)
		var end_point = Vector2(0,0)
		end_point.x += rand_range(0,640)
		end_point.y -= rand_range(20,480)
		new_bullet.init(spawn_point, end_point)
		add_child(new_bullet)

func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()
