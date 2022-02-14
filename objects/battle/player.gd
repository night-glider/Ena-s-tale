extends Sprite


func _process(delta):
	if Input.is_action_pressed("walk_left"):
		position.x-=1
	if Input.is_action_pressed("walk_right"):
		position.x+=1
	if Input.is_action_pressed("walk_backward"):
		position.y+=1
	if Input.is_action_pressed("walk_forward"):
		position.y-=1
	
	if Input.is_action_just_pressed("interact"):
		for element in $Area2D.get_overlapping_areas():
			if element.is_in_group("option_hitbox"):
				element.get_parent().press()
