extends Control

func _process(delta):
	$task_panel/time.text = str(OS.get_datetime()["hour"]) + ":" + str(OS.get_datetime()["minute"]) + ":" + str(OS.get_datetime()["second"])
	
	if Input.is_action_just_pressed("LMB"):
		$start.visible = false


func _on_Button_pressed():
	$error.visible = true


func _on_ERROR_Button_pressed():
	$error.visible = false


func _on_start_btn_pressed():
	$start.visible = true


func _on_exit_pressed():
	$quit_shader.visible = true
	$quit.visible = true


func _on_yes_pressed():
	get_tree().quit()


func _on_no_pressed():
	$quit_shader.visible = false
	$quit.visible = false


func _on_start_game_pressed():
	get_tree().change_scene("res://locations/main_menu.tscn")
