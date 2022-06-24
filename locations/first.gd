extends Control

func _ready():
	if SaveData.load_data("disable_intro", false):
		get_tree().change_scene("res://locations/main.tscn")
	else:
		get_tree().change_scene("res://locations/startup.tscn")
