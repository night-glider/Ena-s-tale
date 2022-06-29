extends Node

signal attack_ended
const alert = preload("res://objects/battle/attacks/alert.tscn")

export var box_position := Vector2(252,221)
export var box_size := Vector2(136, 136)

export var export_attack_duration:float = 10




func _ready():
	$self_destruct.start(export_attack_duration)

func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()
