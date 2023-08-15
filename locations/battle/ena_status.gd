extends ReferenceRect

var is_hurt = false
var current_state = "sad"

func _process(delta):
	if is_hurt:
		$AnimatedSprite.position.x = 2 + rand_range(-1.5,1.5)
		$AnimatedSprite.position.y = 2 + rand_range(-1.5,1.5)

func _on_player_got_hit(dmg):
	is_hurt = true
	if current_state == "rage":
		$AnimatedSprite.play("rage_hurt")
	else:
		$AnimatedSprite.play("hurt")
	$hurt_timer.start()


func _on_hurt_timer_timeout():
	$AnimatedSprite.play(current_state)
	is_hurt = false
	$AnimatedSprite.position = Vector2(2,2)


func _on_player_stance_changed(new_stance):
	if new_stance == 1:
		current_state = "sad"
		$AnimatedSprite.play(current_state)
	elif new_stance == 2:
		current_state = "rage"
		$AnimatedSprite.play(current_state)
