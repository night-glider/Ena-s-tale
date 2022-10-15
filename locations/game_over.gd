extends Control



func _ready():
	$soul.position = Globals.game_over_soul_position
	$AnimationPlayer.play("game_over")
	
	$hand.init($soul.position)
	
	var death_count = SaveData.load_data("death_count", 0)
	death_count+=1
	SaveData.save_data("death_count", death_count)
	

func _on_Timer_timeout():
	if SaveData.load_data("death_count", 0) == 4:
		get_tree().change_scene("res://locations/game_over_dialogue.tscn")
		return
	
	get_tree().change_scene("res://locations/main_menu.tscn")
