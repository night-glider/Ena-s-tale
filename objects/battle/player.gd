extends KinematicBody2D

var hp := 100
var heal_buffer = 0
var invincible = false
var damage = 2000
var spd = 120


enum stances {NORMAL = 0, GLACIAL = 1, INFERNAL = 2}
var stance = stances.NORMAL

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		for element in $hitbox.get_overlapping_areas():
			if element.is_in_group("option_hitbox") and element.is_visible_in_tree():
				element.get_parent().press()
				return

func _physics_process(delta):
	var input:Vector2 = Vector2.ZERO
	
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

func change_stance(new_stance:int):
	stance = new_stance
	
	match stance:
		stances.NORMAL:
			damage = 2000
		stances.GLACIAL:
			damage = 1500
		stances.INFERNAL:
			damage = 2500
