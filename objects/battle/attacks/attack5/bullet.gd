extends Area2D

var velocity:float
var acceleration:float
var bottom_y:int
var scatter:float
var scatter_count:int
var small_fireball_speed:float

const bullet_small = preload("res://objects/battle/attacks/attack5/bullet_small.tscn")

func init(spd:float, accel:float, bottom:int, scatt:float, scatt_count:int, small_spd:float):
	velocity = spd
	acceleration = accel
	bottom_y = bottom
	scatter = scatt
	scatter_count = scatt_count
	small_fireball_speed = small_spd

func spawn_scatter():
	for i in range(scatter_count):
		var new_bullet = bullet_small.instance()
		new_bullet.init(small_fireball_speed)
		new_bullet.position.x = position.x + rand_range(-scatter, scatter)
		new_bullet.position.y = position.y + rand_range(-scatter, scatter)
		get_parent().add_child(new_bullet)

func touch_player():
	spawn_scatter()
	queue_free()

func _process(delta):
	position.y += velocity
	velocity+=acceleration
	if position.y >= bottom_y:
		spawn_scatter()
		queue_free()

func _on_Timer_timeout():
	queue_free()

