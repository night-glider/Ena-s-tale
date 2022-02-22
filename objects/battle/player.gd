extends Sprite

var hp := 100
var heal_buffer = 0
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
			if element.is_in_group("option_hitbox") and element.is_visible_in_tree():
				element.get_parent().press()
				return

func _on_Area2D_area_entered(area):
	if not invincible:
		if area.is_in_group("enemy_bullet"):
			take_hit(10)
			area.touch_player()

func take_hit(damage:int):
	hp-=damage
	hp = clamp(hp, 0, 100)
	invincible = true
	$AnimationPlayer.play("invincible")
	$invincibility.start()

func _on_invincibility_timeout():
	$AnimationPlayer.stop()
	invincible = false

func heal(heal_amount, instant = false):
	if instant:
		hp+=heal_amount
		hp = clamp(hp, 0, 100)
	else:
		heal_buffer+=heal_amount


func _on_heal_time_timeout():
	if heal_buffer > 0:
		hp+=1
		heal_buffer-=1
		hp = clamp(hp, 0,100)
