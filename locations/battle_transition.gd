extends Control

func _ready():
	$AnimationPlayer.play("start")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://locations/battle/battle.tscn")
