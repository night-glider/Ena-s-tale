extends Control

export(Array, String, MULTILINE) var logs

var id = 0
var char_progress = 0

func _ready():
	for i in logs.size():
		logs[i] = tr(logs[i])

func _process(delta):
	
	if Input.is_action_just_pressed("interact"):
		if(id == logs.size()):
			get_tree().change_scene( "res://locations/login_screen.tscn" )
			return
		$label.bbcode_text = ""
		id+=1
		char_progress = 0
		return

func _on_Timer_timeout():
	if(id == logs.size()):
		get_tree().change_scene( "res://locations/login_screen.tscn" )
		return
	if(char_progress == logs[id].length()):
		$label.bbcode_text = ""
		id+=1
		char_progress = 0
		return
	if(logs[id][char_progress] == "["):
		while(logs[id][char_progress] != "]"):
			$label.bbcode_text+=logs[id][char_progress]
			char_progress+=1
		$label.bbcode_text+=logs[id][char_progress]
		char_progress+=1
		return
	
	if(logs[id][char_progress] == "%"):
		char_progress+=1
		while(logs[id][char_progress] != "%"):
			$label.bbcode_text+=logs[id][char_progress]
			char_progress+=1
		char_progress+=1
		return
	
	
	if(logs[id][char_progress] == "@"):
		char_progress+=1
		var new_str = ""
		while(logs[id][char_progress] != "@"):
			new_str+=logs[id][char_progress]
			char_progress+=1
		$Timer.wait_time = float(new_str)
		char_progress+=1
		return
	
	$label.bbcode_text+=logs[id][char_progress]
	char_progress+=1
	return
	
