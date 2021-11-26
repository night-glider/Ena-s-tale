extends Node
class_name global

var player_name:String
var error_message:String


func crash(msg:String):
	error_message = msg
	get_tree().change_scene("res://locations/crash_screen.tscn")
