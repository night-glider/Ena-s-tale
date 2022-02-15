extends Node2D

var bullet = preload("res://objects/battle/attacks/attack1/bullet.tscn")
var active = true
var amp = 50
var origin:Vector2
var spd = PI/240

var bullet_spd = 5
var bullet_damp = 0.99
var bullet_angle = 0.1

var n = 0

func _ready():
	origin = position
	

func _process(delta):
	position.y = origin.y + sin(n)*amp
	n+=spd

func _on_spawn_timer_timeout():
	if active:
		var new_bullet = bullet.instance()
		new_bullet.position = position
		new_bullet.position.y += rand_range(-10,10)
		new_bullet.damp = bullet_damp
		new_bullet.spd = bullet_spd
		new_bullet.angle = bullet_angle
		get_parent().add_child(new_bullet)

func _on_pause_timer_timeout():
	active = false
	$active_timer.start()

func _on_active_timer_timeout():
	active = true
	$pause_timer.start()
