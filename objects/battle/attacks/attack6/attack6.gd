extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack6/bullet.tscn")

export var box_position := Vector2(170,221)
export var box_size := Vector2(300, 136)

export var export_attack_duration:float = 10
export var export_attack_delay:float = 1
export var export_spawn_bullet_interval:float = 0.1
export var export_spawn_bullet_time:float = 5
export var export_bullet_curve_r:float = 100
export var export_bullet_anim_spd:float = 1.0/120.0
export var export_bullet_fly_up_spd:float = 2




func _ready():
	$self_destruct.start(export_attack_duration)
	
	$Periodic.add_method(self, "spaw_bullet", [], export_spawn_bullet_interval, export_attack_delay, export_spawn_bullet_time)

func spaw_bullet():
	var side = [0,1][randi()%2]
	var r = [-1,1][side] * export_bullet_curve_r
	var box = [0,1][side]
	
	var new_bullet = bullet.instance()
	var end_pos = box_position
	end_pos.y += box_size.y
	end_pos.x += box_size.x * box
	var fly_pos = box_position
	fly_pos.y += box_size.y
	fly_pos.x += rand_range(0, box_size.x)
	
	new_bullet.init(Vector2(320,50), end_pos, export_bullet_anim_spd, r, fly_pos, export_bullet_fly_up_spd)
	add_child(new_bullet)

func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()
