extends Node2D


func _process(delta):
	if $AnimatedSprite.frame == 4:
		queue_free()
	
