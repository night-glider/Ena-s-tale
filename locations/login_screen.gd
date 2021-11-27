extends Control

export(Array, String) var nicknames
export(Array, String, MULTILINE) var messages

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	for i in messages.size():
		messages[i] = tr(messages[i])

func _on_Button_pressed():
	if $login/login.text.to_lower() == "razoldon":
		get_tree().quit()
		return
	
	if $login/login.text.to_lower() in nicknames:
		var id = nicknames.find($login/login.text.to_lower())
		Globals.crash( messages[id])
		return
	
	get_tree().change_scene("res://locations/desktop.tscn")
