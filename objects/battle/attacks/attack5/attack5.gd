extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack5/bullet.tscn")

export var box_position := Vector2(200,221)
export var box_size := Vector2(250, 136)

export var export_attack_duration:float = 10
export var export_attack_delay:float = 1
export var export_attack_interval:float = 1
export var export_bullet_radius:float = 5
export var export_bullet_initial_speed:float = 0
export var export_bullet_acceleration:float = 0.5
export var export_small_fireball_count:int = 10
export var export_small_fireball_scatter:float = 10
export var export_small_fireball_speed:float = 1

var player = null
var enemy = null


func _ready():
	enemy.sword_down_static()
	$self_destruct.start(export_attack_duration)
	
	$timer.start(export_attack_delay)
	$timer.wait_time = export_attack_interval

func _on_self_destruct_timeout():
	enemy.sword_up()
	emit_signal("attack_ended")
	queue_free()


func _on_timer_timeout():
	var center = box_position.x + box_size.x/2
	var delta = box_size.x/4
	
	center += delta * [-1,1][randi()%2]
	
	var new_bullet = bullet.instance()
	new_bullet.init(
		export_bullet_initial_speed, 
		export_bullet_acceleration,
		box_position.y + box_size.y,
		export_small_fireball_scatter,
		export_small_fireball_count,
		export_small_fireball_speed)
	new_bullet.position.x = center
	new_bullet.position.y = 50
	new_bullet.scale.x = export_bullet_radius
	new_bullet.scale.y = export_bullet_radius
	add_child(new_bullet)
	
