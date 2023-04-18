extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack5/bullet.tscn")

export var box_position := Vector2(252,221)
export var box_size := Vector2(136, 136)

export var export_attack_duration:float = 10
export var export_attack_delay:float = 1
export var export_attack_interval:float = 1
export var export_bullet_width:float = 5
export var export_bullet_initial_speed:float = 0
export var export_bullet_acceleration:float = 0.5

var player = null
var enemy = null


func _ready():
	$self_destruct.start(export_attack_duration)
	
	$timer.start(export_attack_delay)
	$timer.wait_time = export_attack_interval

func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()


func _on_timer_timeout():
	var center = box_position.x + box_size.x/2
	var delta = box_size.x/4
	
	center += delta * [-1,1][randi()%2]
	
	var new_bullet = bullet.instance()
	new_bullet.init(export_bullet_initial_speed, export_bullet_acceleration)
	new_bullet.position.x = center
	new_bullet.position.y = 50
	new_bullet.scale.x = export_bullet_width
	add_child(new_bullet)
	
