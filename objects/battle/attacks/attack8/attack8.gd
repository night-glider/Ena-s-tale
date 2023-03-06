extends Node

signal attack_ended
const bullet = preload("res://objects/battle/attacks/attack8/bullet.tscn")
const spark = preload("res://objects/battle/attacks/attack8/spark.tscn")
const eye_flash_sound = preload("res://sounds/eyeflash.ogg")

export var box_position := Vector2(252,221)
export var box_size := Vector2(136, 136)

export var export_attack_duration:float = 10
export var export_spark_delay:float = 1
export var export_spark_interval:float = 0.5
export var export_spark_stage_duration:float = 5
export var export_attack_interval:float = 0.5
export var export_attack_delay:float = 6
export var export_attack_durtaion:float = 5
export var export_spark_spawn_x:int = 320
export var export_spark_spawn_y:int = 100
export var export_bullet_spawn_x:int = 320
export var export_bullet_spawn_y:int = 100
export var export_bullet_speed:float = 2
export var export_bullet_width:float = 10


var decisions = []

func _ready():
	$self_destruct.start(export_attack_duration)
	
	$Periodic.add_method(self, "make_decision", [], export_spark_interval, export_spark_delay, export_spark_stage_duration)
	$Periodic.add_method(self, "spawn_attack", [], export_attack_interval, export_attack_delay, export_attack_durtaion)

func make_decision():
	var new_spark = spark.instance()
	new_spark.position = Vector2(export_spark_spawn_x, export_spark_spawn_y)
	add_child(new_spark)
	Globals.play_sound(eye_flash_sound)
	
	var attack_type = randi()%2
	decisions.append(attack_type)
	if attack_type == 0:
		new_spark.modulate = Color.yellow
	else:
		new_spark.modulate = Color.red

func spawn_attack():
	var new_bullet = bullet.instance()
	new_bullet.position = Vector2(export_bullet_spawn_x,export_bullet_spawn_y)
	add_child(new_bullet)
	new_bullet.init(export_bullet_speed)
	new_bullet.scale.x = export_bullet_width
	
	var attack_type = decisions.pop_front()
	if attack_type == 0:
		new_bullet.modulate = Color.yellow
		new_bullet.add_to_group("enemy_bullet_yellow")
	else:
		new_bullet.modulate = Color.red
		new_bullet.add_to_group("enemy_bullet_red")
	

func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()
