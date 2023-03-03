extends KinematicBody2D

signal got_hit(dmg)
signal stance_changed(new_stance)

var hp := 100
var heal_stack = []
var can_regen = false
var invincible = false
var damage = 500
var spd = 120
var gravity = 10
var jump_force = 120
var jump_velocity = 0
var can_jump = false
var max_jump_frames = 60
var jump_frames = max_jump_frames
var previous_position = Vector2.ZERO


enum stances {SAD = 1, RAGE = 2}
var stance = stances.SAD

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
	
	if is_on_floor():
		can_jump = true
		jump_frames = max_jump_frames
		jump_velocity = 1
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
		jump_velocity = -jump_force
		jump_frames -= 1
	else:
		jump_velocity += gravity
	
	return input.normalized() * spd + Vector2(0, jump_velocity)

func _physics_process(delta):
	var actual_velocity = Vector2.ZERO
	
	if mode == modes.NORMAL:
		actual_velocity = normal_mode()
	if mode == modes.BLUE:
		actual_velocity = blue_mode()
	
	
	previous_position = position
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
			return
		
		if area.is_in_group("enemy_bullet_red"):
			if previous_position != position:
				take_hit(10)
				area.touch_player()
				return
		
		if area.is_in_group("enemy_bullet_yellow"):
			if previous_position == position:
				take_hit(10)
				area.touch_player()
				return

func take_hit(dmg:int):
	emit_signal("got_hit", dmg)
	match stance:
		stances.SAD:
			hp-=dmg*0.5
		stances.RAGE:
			hp-=dmg*1.5
	
	if hp <= 0:
		Globals.game_over(position)
	
	hp = clamp(hp, 0, 100)
	invincible = true
	$AnimationPlayer.play("invincible")
	$invincibility.start()

func _on_invincibility_timeout():
	$AnimationPlayer.stop()
	invincible = false

func heal(instant_heal:int, stack:Array):
	hp+=instant_heal
	hp = clamp(hp, 0, 100)
	
	heal_stack.append_array(stack)
	
	can_regen = false

func _on_heal_time_timeout():
	if can_regen:
		if not heal_stack.empty():
			hp += heal_stack.pop_front()
			hp = clamp(hp, 0,100)

func change_stance(new_stance:int):
	stance = new_stance
	
	match stance:
		stances.SAD:
			damage = 1500
		stances.RAGE:
			damage = 2500
	
	emit_signal("stance_changed", stance)

func change_mode(new_mode:int):
	mode = new_mode
	
	match mode:
		modes.NORMAL:
			$Sprite.modulate = Color.white
		modes.BLUE:
			$Sprite.modulate = Color.blue
