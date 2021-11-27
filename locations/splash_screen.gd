extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		get_tree().change_scene("res://locations/login_screen.tscn")

func _on_Timer_timeout():
	get_tree().change_scene("res://locations/login_screen.tscn")
