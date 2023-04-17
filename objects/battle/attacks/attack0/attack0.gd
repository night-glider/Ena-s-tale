extends Node

signal attack_ended
const alert = preload("res://objects/battle/attacks/alert.tscn")
const bullet = preload("res://objects/battle/attacks/attack0/bullet.tscn")

export var box_position := Vector2(252,221)
export var box_size := Vector2(136, 136)

export var export_attack_duration:float = 10

export var export_spawn_probability:float = 0.5
export var export_bullet_gravity:float = 0.025
export var export_safe_zone_radius:int = 25

var player = null



func _ready():
	$self_destruct.start(export_attack_duration)

func _process(delta):
	var spawn = randf()
	if spawn < export_spawn_probability:
		var new_bullet = bullet.instance()
		var pos = box_position
		pos.y -= 10
		pos.x += rand_range(0, box_size.x)
		new_bullet.init(pos, export_bullet_gravity, player, export_safe_zone_radius)
		add_child(new_bullet)

func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()
