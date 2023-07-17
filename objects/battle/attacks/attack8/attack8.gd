extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack8/bullet.tscn")
const spark = preload("res://objects/battle/attacks/attack8/spark.tscn")
const eye_flash_sound = preload("res://sounds/eyeflash_first.ogg")
const eye_flash_sound_last = preload("res://sounds/eyeflash_last.ogg")
const swing_sound = preload("res://sounds/sword_slash.ogg")

export var box_position := Vector2(252,221)
export var box_size := Vector2(136, 136)

export var export_attack_duration:float = 9.2
export var export_spark_delay:float = 0.5
export var export_spark_interval:float = 0.4
export var export_spark_last_sound:int = 4
export var export_spark_stage_duration:float = 1.2
export var export_attack_interval:float = 25.0/15.0
export var export_attack_delay:float = 3
export var export_attack_durtaion:float = 6
export var export_spark_spawn_x1:int = 310
export var export_spark_spawn_x2:int = 330
export var export_spark_spawn_y:int = 90
export var export_bullet_spawn_x:int = 320
export var export_bullet_spawn_y:int = 175
export var export_bullet_speed:float = 5
export var export_bullet_width:float = 10

var player = null
var enemy = null

var decisions = []

func _ready():
	$self_destruct.start(export_attack_duration)
	enemy.start_shadow_anim()
	
	$Periodic.add_method(self, "make_decision", [], export_spark_interval, export_spark_delay, export_spark_stage_duration)
	$Periodic.add_method(self, "spawn_attack", [], export_attack_interval, export_attack_delay, export_attack_durtaion)
	$Periodic.add_method_oneshot(self, "start_swing", [], export_attack_delay)

func make_decision():
	var new_spark = spark.instance()
	if len(decisions) % 2 == 0:
		new_spark.position = Vector2(export_spark_spawn_x1, export_spark_spawn_y)
	else:
		new_spark.position = Vector2(export_spark_spawn_x2, export_spark_spawn_y)
	add_child(new_spark)
	
	var attack_type = randi()%2
	decisions.append(attack_type)
	if attack_type == 0:
		new_spark.modulate = Color.yellow
	else:
		new_spark.modulate = Color.red
	
	if len(decisions) < export_spark_last_sound:
		Globals.play_sound(eye_flash_sound)
	else:
		Globals.play_sound(eye_flash_sound_last)

func spawn_attack():
	var new_bullet = bullet.instance()
	new_bullet.position = Vector2(export_bullet_spawn_x,export_bullet_spawn_y)
	add_child(new_bullet)
	new_bullet.init(export_bullet_speed)
	#new_bullet.scale.x = export_bullet_width
	
	var attack_type = decisions.pop_front()
	if attack_type == 0:
		new_bullet.modulate = Color.yellow
		new_bullet.add_to_group("enemy_bullet_yellow")
	else:
		new_bullet.modulate = Color.red
		new_bullet.add_to_group("enemy_bullet_red")
	
	Globals.play_sound(swing_sound)

func start_swing():
	enemy.start_swing_anim()

func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	enemy.toggle_default_animation()
	queue_free()
