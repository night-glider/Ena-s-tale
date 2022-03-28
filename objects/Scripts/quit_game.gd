extends Control


var alpha = 0

func _process(delta):
	if Input.is_action_pressed("quit"):
		alpha+=1.2/180
	else:
		alpha = 0
	
	$Label.modulate.a = alpha
	
	if alpha > 1.2:
		get_tree().quit()
