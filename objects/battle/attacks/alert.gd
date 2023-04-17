extends Node2D

const frame0 = preload("res://sprites/battle/alert_0.png")
const frame1 = preload("res://sprites/battle/alert_1.png")

onready var sprite = $ColorRect

var do_sound = true

func init(pos:Vector2, size:Vector2, time:float, sound=true):
	do_sound = sound
	position = pos
	sprite.margin_left = -size.x/2
	sprite.margin_right = -sprite.margin_left
	sprite.margin_bottom = size.y/2
	sprite.margin_top = -sprite.margin_bottom
	$destruction.start(time)



func _on_Timer_timeout():
	if do_sound:
		$AudioStreamPlayer.play()
	if sprite.texture == frame0:
		sprite.texture = frame1
	else:
		sprite.texture = frame0


func _on_destruction_timeout():
	queue_free()
