extends Area2D

var n = 0
var n_spd = 0.1
var spd = 5
var amplitude = 20

var offset_y = 0


func _ready():
	offset_y = position.y

func touch_player():
	queue_free()

func _process(delta):
	position.x += spd
	position.y = offset_y + sin(n) * amplitude
	n += n_spd

func _on_Timer_timeout():
	queue_free()

