extends Node
class_name global

var player_name:String
var error_message:String
var game_over_soul_position:Vector2 = Vector2.ZERO


func crash(msg:String):
	error_message = msg
	get_tree().change_scene("res://locations/crash_screen.tscn")


func game_over(soul_position:Vector2 = Vector2(-100,-100)):
	game_over_soul_position = soul_position
	get_tree().change_scene("res://locations/game_over.tscn")
