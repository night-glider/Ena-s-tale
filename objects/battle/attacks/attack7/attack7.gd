extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack7/bullet.tscn")

export var box_position := Vector2(252,221)
export var box_size := Vector2(136, 136)

export var export_attack_duration:float = 10
export var export_start_square_radius:float = 25
export var export_bullet_count:int = 100
export var export_bullet_height:int = 480
export var export_bullet_spd:float = 2

var player = null

func _ready():
	$self_destruct.start(export_attack_duration)
	
	for i in export_bullet_count:
		var new_bullet = bullet.instance()
		var spawn_point = Vector2(320,50)
		spawn_point.x += rand_range(-export_start_square_radius,export_start_square_radius)
		spawn_point.y += rand_range(-export_start_square_radius,export_start_square_radius)
		var end_point = Vector2(0,0)
		end_point.x += rand_range(0,640)
		end_point.y -= rand_range(0,export_bullet_height)
		new_bullet.init(spawn_point, end_point, export_bullet_spd)
		add_child(new_bullet)

func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()
