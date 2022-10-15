extends Control

var option = ""
var stage = 0


func _ready():
	$DialogueLabel.start_dialogue()


func _process(delta):
	if stage == 0:
		if Input.is_action_just_pressed("walk_left"):
			option = "yes"
			$yes.modulate = Color.yellow
			$no.modulate = Color.gray
		if Input.is_action_just_pressed("walk_right"):
			option = "no"
			$no.modulate = Color.yellow
			$yes.modulate = Color.gray
		
		if Input.is_action_just_pressed("interact"):
			if option == "no":
				get_tree().quit()
			if option == "yes":
				$DialogueLabel.change_messages(["GAME_OVER_DIALOGUE1", "GAME_OVER_DIALOGUE2"])
				$DialogueLabel.start_dialogue()
				$yes.queue_free()
				$no.queue_free()
				stage = 1
			return
	
	if stage == 1:
		if Input.is_action_just_pressed("interact"):
			$DialogueLabel.next_message()




func _on_DialogueLabel_dialogue_ended():
	get_tree().change_scene("res://locations/battle/battle.tscn")
