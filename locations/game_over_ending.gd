extends Control


func _ready():
	$AnimationPlayer.play("cutscene")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().quit()
