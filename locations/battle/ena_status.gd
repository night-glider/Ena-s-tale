extends ReferenceRect

var is_hurt = false

func _process(delta):
	if is_hurt:
		$AnimatedSprite.position.x = 2 + rand_range(-1.5,1.5)
		$AnimatedSprite.position.y = 2 + rand_range(-1.5,1.5)

func _on_player_got_hit(dmg):
	is_hurt = true
	$AnimatedSprite.play("hurt")
	$hurt_timer.start()


func _on_hurt_timer_timeout():
	$AnimatedSprite.play("sad")
	is_hurt = false
	$AnimatedSprite.position = Vector2(2,2)
