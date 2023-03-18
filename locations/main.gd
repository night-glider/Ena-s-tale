extends Spatial



func _on_god_ray_trigger_body_entered(body):
	if body.name == "player":
		$OmniLight/GodRays.visible = true
		#$AudioStreamPlayerInterpolated.change_music(preload("res://OST/Kalimba.mp3"), 1)


func _on_god_ray_trigger_body_exited(body):
	if body.name == "player":
		$OmniLight/GodRays.visible = false
		#$AudioStreamPlayerInterpolated.change_music(preload("res://OST/Maid with the Flaxen Hair.mp3"), 1)


func _on_frog_ending_body_entered(body):
	if body.name == "player":
		get_tree().change_scene("res://locations/frog_ending.tscn")
