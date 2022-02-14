extends Sprite

var hp = 100
var invincible = false

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


func _on_Area2D_area_entered(area):
	if not invincible:
		if area.is_in_group("enemy_bullet"):
			take_hit(10)
			area.touch_player()

func take_hit(damage:int):
	hp-=damage
	invincible = true
	$AnimationPlayer.play("invincible")
	$invincibility.start()


func _on_invincibility_timeout():
	$AnimationPlayer.stop()
	invincible = false
