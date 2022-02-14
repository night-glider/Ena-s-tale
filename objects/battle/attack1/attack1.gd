extends Node

signal attack_ended

export var box_position := Vector2(35+100,221)
export var box_size := Vector2(571-100, 136)

func _ready():
	OS.alert("test")
	$firethrower.position = box_position
	$firethrower.position.y += box_size.y/2
	$firethrower.origin = $firethrower.position



func _on_self_destruct_timeout():
	emit_signal("attack_ended")
	queue_free()
