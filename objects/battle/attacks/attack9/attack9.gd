extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack9/bullet.tscn")

export var box_position := Vector2(252,221)
export var box_size := Vector2(136, 136)

export var export_attack_duration:float = 20
export var export_spawn_position:float = 0
export var export_bullet_speed:float = 2
export var export_bullet_wobble:float = 5
export var export_bullet_size:float = 10

var player = null
var enemy = null

func _ready():
	$self_destruct.start(export_attack_duration)
	
	var new_bullet = bullet.instance()
	var target = box_position + box_size/2
	new_bullet.init(Vector2(310,export_spawn_position), target, export_bullet_speed, export_bullet_wobble)
	new_bullet.scale = Vector2(export_bullet_size,export_bullet_size)
	add_child(new_bullet)
	

func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()
