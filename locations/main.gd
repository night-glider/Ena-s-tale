extends Spatial



func _on_god_ray_trigger_body_entered(body):
	if body.name == "player":
		$OmniLight/GodRays.visible = true


func _on_god_ray_trigger_body_exited(body):
	if body.name == "player":
		$OmniLight/GodRays.visible = false
