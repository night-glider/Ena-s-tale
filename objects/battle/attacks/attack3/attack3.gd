extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack3/bullet.tscn")
const alert = preload("res://objects/battle/attacks/alert.tscn")

export var box_position := Vector2(35+100,221)
export var box_size := Vector2(500-100, 136)

export var export_attack_duration:float = 10
export var export_attack_interval:float = 5
export var export_attack_width:int = 50
export var export_attack_start_delay:float = 1
export var export_bullet_spawn_x:float = 320
export var export_bullet_spawn_y:float = 100
export var export_bursts_count:int = 2
export var export_particle_count:float = 10
export var export_burst_time:float = 1
export var export_alert_time:float = 1



func _ready():
	$self_destruct.start(export_attack_duration)
	$attack.start(export_attack_start_delay)
	$attack.wait_time = export_attack_interval
	

func spawn_bullets(vel:Vector2):
	var new_bullet = bullet.instance()
	add_child(new_bullet)
	new_bullet.position = Vector2(export_bullet_spawn_x + rand_range(-export_attack_width/5,export_attack_width/5), export_bullet_spawn_y)
	new_bullet.init(vel, box_position.y + box_size.y)

func attack():
	for i in export_bursts_count:
		var new_alert = alert.instance()
		add_child(new_alert)
		var pos = Vector2( rand_range(box_position.x + export_attack_width/2, box_position.x + box_size.x - export_attack_width/2), box_position.y + box_size.y/2 )
		new_alert.init( pos, Vector2(export_attack_width,box_size.y), export_alert_time )
		
		var velocity:Vector2
		velocity = Vector2(export_bullet_spawn_x, export_bullet_spawn_y).direction_to(pos) * 10
		$Periodic.add_method(self, "spawn_bullets", [ velocity ], export_burst_time / export_particle_count, export_alert_time, export_burst_time)


func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()

func _on_attack_timeout():
	attack()


