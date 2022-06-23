extends KinematicBody2D

var hp := 100
var heal_buffer = 0
var heal_last_amount = 0
var can_regen = false
var invincible = false
var damage = 2000
var spd = 120
var gravity = 120
var jump_force = 120
var can_jump = false
var max_jump_frames = 60
var jump_frames = max_jump_frames


enum stances {NORMAL = 0, GLACIAL = 1, INFERNAL = 2}
var stance = stances.NORMAL

enum modes {NORMAL = 0, BLUE = 1}
var mode = modes.NORMAL



func _process(delta):
	pass

func normal_mode()->Vector2:
	var input:Vector2 = Vector2.ZERO
	
	if visible:
		if Input.is_action_pressed("walk_left"):
			input.x-=1
		if Input.is_action_pressed("walk_right"):
			input.x+=1
		if Input.is_action_pressed("walk_backward"):
			input.y+=1
		if Input.is_action_pressed("walk_forward"):
			input.y-=1
	
	return input.normalized() * spd

func blue_mode()->Vector2:
	$Label.text = str(jump_frames)
	
	var input:Vector2 = Vector2.ZERO
	var jump:Vector2 = Vector2.ZERO
	
	if is_on_floor():
		can_jump = true
		jump_frames = max_jump_frames
	else:
		if can_jump and Input.is_action_pressed("walk_forward") and jump_frames > 0:
			can_jump = true
		else:
			can_jump = false
	
	if Input.is_action_pressed("walk_left"):
		input.x-=1
	if Input.is_action_pressed("walk_right"):
		input.x+=1
	if Input.is_action_pressed("walk_backward"):
		pass
	
	
	if can_jump and Input.is_action_pressed("walk_forward"):
		jump.y = - (gravity + jump_force)
		jump_frames -= 1
	
	return input.normalized() * spd + Vector2.DOWN * gravity + jump 

func _physics_process(delta):
	var actual_velocity = Vector2.ZERO
	
	if mode == modes.NORMAL:
		actual_velocity = normal_mode()
	if mode == modes.BLUE:
		actual_velocity = blue_mode()
	
	move_and_slide(actual_velocity, Vector2.UP)
	
	if visible and Input.is_action_just_pressed("interact"):
		for element in $hitbox.get_overlapping_areas():
			if element.is_in_group("option_hitbox") and element.is_visible_in_tree():
				element.get_parent().press()
				return

func _on_Area2D_area_entered(area):
	if not invincible:
		if area.is_in_group("enemy_bullet"):
			take_hit(10)
			area.touch_player()

func take_hit(damage:int):
	match stance:
		stances.GLACIAL:
			hp-=damage*0.5
		stances.INFERNAL:
			hp-=damage*1.5
		stances.NORMAL:
			hp-=damage
	
	if hp <= 0:
		Globals.game_over(position)
	
	hp = clamp(hp, 0, 100)
	invincible = true
	$AnimationPlayer.play("invincible")
	$invincibility.start()

func _on_invincibility_timeout():
	$AnimationPlayer.stop()
	invincible = false

func heal(instant_heal:int, regen_heal:int):
	hp+=instant_heal
	hp = clamp(hp, 0, 100)
	
	heal_last_amount = 0
	heal_buffer += regen_heal
	can_regen = false

func _on_heal_time_timeout():
	if can_regen:
		if heal_buffer > 0:
			if heal_last_amount <= 0:
				hp+=25
				heal_last_amount = 25
				heal_buffer-=25
			else:
				hp+=clamp(heal_last_amount-5, 0, heal_buffer)
				heal_last_amount-5
				heal_buffer-=heal_last_amount
			hp = clamp(hp, 0,100)

func change_stance(new_stance:int):
	stance = new_stance
	
	match stance:
		stances.NORMAL:
			damage = 2000
		stances.GLACIAL:
			damage = 1500
		stances.INFERNAL:
			damage = 2500

func change_mode(new_mode:int):
	mode = new_mode
	
	match mode:
		modes.NORMAL:
			$Sprite.modulate = Color.white
		modes.BLUE:
			$Sprite.modulate = Color.blue
