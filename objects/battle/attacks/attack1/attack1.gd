extends Node

signal attack_ended

export var box_position := Vector2(35+100,221)
export var box_size := Vector2(571-100, 136)

export var export_amplitude = 50
export var export_attack_duration = 10.0
export var export_firethrower_spd = PI/240
export var export_fire_spawn_interval = 0.1
export var export_pause_duration = 1.0
export var export_pause_interval = 3.0
export var export_bullet_angle_spread = 0.1
export var export_bullet_spd = 5
export var export_bullet_spd_damp = 0.99

var player = null

func _ready():
	$self_destruct.start(export_attack_duration)
	$firethrower.amp = export_amplitude
	$firethrower.spd = export_firethrower_spd
	$firethrower/spawn_timer.wait_time = export_fire_spawn_interval
	$firethrower/active_timer.wait_time = export_pause_duration
	$firethrower/pause_timer.wait_time = export_pause_interval
	
	$firethrower.bullet_angle = export_bullet_angle_spread
	$firethrower.bullet_spd = export_bullet_spd
	$firethrower.bullet_damp = export_bullet_spd_damp
	
	$firethrower.position = box_position
	$firethrower.position.y += box_size.y/2
	$firethrower.origin = $firethrower.position
	
	$firethrower/spawn_timer.start()
	$firethrower/pause_timer.start()



func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()
