extends Control

var options = []
var current_option = 0

func _ready():
	options.append($continue)
	options.append($options)
	options.append($quit)
	options[current_option].modulate = Color.yellow

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if visible:
			get_tree().paused = false
			visible = false
		else:
			get_tree().paused = true
			visible = true
	
	if not visible:
		return
	
	if Input.is_action_just_pressed("ui_down") and current_option < 2:
		options[current_option].modulate = Color.white
		current_option+=1
		options[current_option].modulate = Color.yellow
	if Input.is_action_just_pressed("ui_up") and current_option > 0:
		options[current_option].modulate = Color.white
		current_option-=1
		options[current_option].modulate = Color.yellow
	
	if Input.is_action_just_pressed("interact"):
		if current_option == 0:
			get_tree().paused = false
			visible = false
		if current_option == 2:
			get_tree().quit()
