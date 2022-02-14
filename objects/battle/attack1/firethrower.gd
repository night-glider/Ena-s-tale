extends Node2D

var bullet = preload("res://objects/battle/attack1/bullet.tscn")
var active = true
var amp = 50
var origin:Vector2
var spd = PI/240

var n = 0

func _ready():
	origin = position
	$pause_timer.start()

func _process(delta):
	position.y = origin.y + sin(n)*amp
	n+=spd

func _on_spawn_timer_timeout():
	if active:
		var new_bullet = bullet.instance()
		new_bullet.position = position
		new_bullet.position.y += rand_range(-10,10)
		get_parent().add_child(new_bullet)

func _on_pause_timer_timeout():
	active = false
	$active_timer.start()

func _on_active_timer_timeout():
	active = true
	$pause_timer.start()
