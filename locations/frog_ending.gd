extends Control



func _on_VideoPlayer_finished():
	$AnimationPlayer.play("default")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().quit()
