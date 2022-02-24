extends KinematicBody2D

var hp := 100
var heal_buffer = 0
var heal_last_amount = 0
var can_regen = false
var invincible = false
var damage = 2000
var spd = 120


enum stances {NORMAL = 0, GLACIAL = 1, INFERNAL = 2}
var stance = stances.NORMAL

func _process(delta):
	pass
	

func _physics_process(delta):
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
	
	input = input.normalized()
	
	move_and_slide(input * spd, Vector2.UP)
	
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
				hp+=1
				heal_last_amount = 1
				heal_buffer-=1
			else:
				hp+=clamp(heal_last_amount*2, 0, heal_buffer)
				heal_last_amount*=2
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
