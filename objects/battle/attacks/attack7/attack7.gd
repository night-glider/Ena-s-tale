extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack7/bullet.tscn")

export var box_position := Vector2(252,221)
export var box_size := Vector2(136, 136)

export var export_attack_duration:float = 10
export var export_particle_spawn_frame:int = 10
export var export_particle_go_frame:int = 70
export var export_start_square_radius:float = 5
export var export_bullet_count:int = 100
export var export_bullet_height:int = 480
export var export_bullet_spd:float = 2

var player = null
var enemy = null

var current_frame = 0
var bullets = []

func _ready():
	enemy.toggle_fire_storm()
	$self_destruct.start(export_attack_duration)
	

func _process(delta):
	current_frame += 1
	
	if current_frame == export_particle_spawn_frame:
		for i in export_bullet_count:
			var new_bullet = bullet.instance()
			var spawn_point = Vector2(320,125)
			spawn_point.x += rand_range(-export_start_square_radius,export_start_square_radius)
			spawn_point.y += rand_range(-export_start_square_radius,export_start_square_radius)
			var end_point = Vector2(0,0)
			end_point.x += rand_range(0,640)
			end_point.y -= rand_range(0,export_bullet_height)
			new_bullet.init(spawn_point, end_point, export_bullet_spd)
			add_child(new_bullet)
			bullets.append(new_bullet)
	
	if current_frame == export_particle_go_frame:
		for bullet in bullets:
			bullet.stage1_toggle()

func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()
