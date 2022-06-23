extends Control



func _ready():
	$soul.position = Globals.game_over_soul_position
	$AnimationPlayer.play("game_over")

func _on_Timer_timeout():
	get_tree().change_scene("res://locations/main_menu.tscn")
