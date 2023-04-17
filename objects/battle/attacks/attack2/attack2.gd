extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack2/bullet.tscn")

export var box_position := Vector2(35+100,221)
export var box_size := Vector2(571-100, 136)

export var export_attack_duration:float = 10
export var export_spawn_interval:float = 4
export var export_platform_spd:float = 0.02
export var export_platform_amplitude:float = 100
export var export_bullet_amplitude = 20
export var export_bullet_spd:float = 2
export var export_bullet_n_spd = -0.05
export var export_dragon_number = 20
export var export_dragon_n_step = 0.5
export var export_dragon_x_step = 15

var player = null

var wall_offset = 0
var n = 0
var side = 1

func _process(delta):
	$wall2.position.x = wall_offset + sin(n) * export_platform_amplitude
	n += export_platform_spd

func _ready():
	get_node("../player").change_mode(1)
	$self_destruct.start(export_attack_duration)
	
	$wall.scale.x = box_size.x/2
	$wall.scale.y = 5
	$wall.position = box_position + box_size
	$wall.position.x -= box_size.x/2
	
	$wall2.scale.x = 20
	$wall2.scale.y = 5
	$wall2.position = box_position + box_size/2
	wall_offset = $wall2.position.x
	
	$dragon_spawn.wait_time = export_spawn_interval
	$dragon_spawn.start()
	
	_on_dragon_spawn_timeout()

func _on_self_destruct_timeout():
	get_node("../player").change_mode(0)
	emit_signal("attack_ended")
	queue_free()

func spawn_bullet(pos:Vector2, bullet_n:float):
	var new_bullet = bullet.instance()
	new_bullet.position = pos
	new_bullet.n = bullet_n
	new_bullet.spd = export_bullet_spd * side
	new_bullet.n_spd = export_bullet_n_spd
	new_bullet.amplitude = export_bullet_amplitude
	add_child(new_bullet)

func _on_dragon_spawn_timeout():
	side *= -1
	var spawn_pos = Vector2.ZERO
	if side == 1:
		spawn_pos = box_position
		spawn_pos.y += box_size.y * 1.0/3
	else:
		spawn_pos = box_position
		spawn_pos.y += box_size.y * 2.0/3
		spawn_pos.x += box_size.x
	
	for i in export_dragon_number:
		spawn_pos.x -= side * export_dragon_x_step
		spawn_bullet(spawn_pos, i * export_dragon_n_step)
		spawn_bullet(spawn_pos, i * export_dragon_n_step + PI)
	
	$dragon_spawn.start()
