extends Control

var heart_pos:int = 0
var heart_poitions = []

func _ready():
	$save1/Label.text = "[" + OS.get_environment("USERNAME") + "]"
	heart_poitions.append($save1/heart_pos)
	heart_poitions.append($save2/heart_pos)
	heart_poitions.append($save3/heart_pos)
	heart_poitions.append($lang/heart_pos)

func _process(delta):
	if Input.is_action_just_pressed("ui_up") and heart_pos > 0:
		heart_pos-=1
	if Input.is_action_just_pressed("ui_down") and heart_pos < 3:
		heart_pos+=1
	$heart.global_position = heart_poitions[heart_pos].rect_global_position
	
	if Input.is_action_just_pressed("interact"):
		if heart_pos == 0:
			get_tree().change_scene("res://locations/main.tscn")
		if heart_pos == 3:
			if $lang.text == "ENGLISH":
				$lang.text = "SPANISH"
			else:
				$lang.text = "ENGLISH"
