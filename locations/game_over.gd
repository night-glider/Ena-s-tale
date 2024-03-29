extends Control

const game_over_ost = preload("res://OST/game_over.ogg")

func _ready():
	Globals.play_sound(game_over_ost)
	$soul.position = Globals.game_over_soul_position
	if $soul.position == Vector2.ZERO:
		$soul.position = Vector2(320,240)
	$AnimationPlayer.play("game_over")
	
	$hand.init($soul.position)
	
	var death_count = SaveData.load_data("death_count", 0)
	death_count+=1
	SaveData.save_data("death_count", death_count)
	

func _on_Timer_timeout():
	if SaveData.load_data("death_count", 0) == 1:
		get_tree().change_scene("res://locations/game_over_ending.tscn")
		return
	
	if SaveData.load_data("death_count", 0) == 4:
		get_tree().change_scene("res://locations/game_over_dialogue.tscn")
		return
	
	get_tree().quit()
