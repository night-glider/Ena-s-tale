extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack4/bullet.tscn")
const alert = preload("res://objects/battle/attacks/alert.tscn")

export var box_position := Vector2(252,221)
export var box_size := Vector2(136, 136)

export var export_attack_duration:float = 10
export var export_first_spawnpoint_x:int = 310
export var export_first_spawnpoint_y:int = 142
export var export_second_spawnpoint_x:int = 330
export var export_second_spawnpoint_y:int = 142
export var export_particles_count:int = 50
export var export_particles_spawn_delay:float = 1.0
export var export_stage1_delay:float = 1
export var export_attack_stage_delay:float = 2
export var export_attack_count:int = 5
export var export_bullet_speed:float = 5
export var export_alert_time:float = 1
export var export_attack_interval:float = 1.5
export var export_alert_count:int = 2
export var export_alert_height:int = 50

var player = null
var enemy = null

var bullet_list = []
var particle_attack_count = 1

func _ready():
	enemy.sword_down_charge()
	$spawn_particles.start(export_particles_spawn_delay)

func _on_spawn_particles_timeout():
	particle_attack_count = round( (export_particles_count / export_attack_count) / export_alert_count ) * 2
	
	$self_destruct.start(export_attack_duration)
	
	for i in export_particles_count:
		var new_bullet = bullet.instance()
		add_child(new_bullet)
		new_bullet.init(Vector2(export_first_spawnpoint_x, export_first_spawnpoint_y), export_stage1_delay, Vector2(box_position.x - rand_range(100,200), box_position.y + rand_range(0, box_size.y)))
		bullet_list.append(new_bullet)
		
	
	for i in export_particles_count:
		var new_bullet = bullet.instance()
		add_child(new_bullet)
		new_bullet.init(Vector2(export_second_spawnpoint_x, export_second_spawnpoint_y), export_stage1_delay, Vector2(box_position.x + box_size.x + rand_range(100,200), box_position.y + rand_range(0, box_size.y)))
		bullet_list.append(new_bullet)
	
	$Periodic.add_method(self, "attack", [], export_attack_interval, export_attack_stage_delay, 999)

func attack():
	if bullet_list.empty():
		return
	
	for i in export_alert_count:
		var new_alert = alert.instance()
		add_child(new_alert)
		var pos = Vector2( box_position.x + box_size.x/2, box_position.y + rand_range(export_alert_height/2, box_size.y - export_alert_height/2) )
		var size = Vector2( box_size.x, export_alert_height)
		new_alert.init( pos, size, export_alert_time )
		
		for j in particle_attack_count:
			var bullet = bullet_list.pop_back()
			if bullet == null:
				return
			bullet.stage3_start(export_alert_time, pos, export_bullet_speed)

func _on_self_destruct_timeout():
	enemy.sword_up()
	emit_signal("attack_ended")
	queue_free()


