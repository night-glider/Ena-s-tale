extends AnimatedSprite

var dialogue_active = false
var hp = 10000

func _process(delta):
	
	if dialogue_active:
		if Input.is_action_just_pressed("interact"):
			if $dialogue.finished:
				$dialogue.next_message()
			else:
				pass
				#$dialogue.skip_message()
		
		if Input.is_action_pressed("cancel"):
			$dialogue.skip_message()

func last_action_decision(action:String)->Array:
	var answer = ["attack"]
	match action:
		"turron": 
			answer[0] = "dialogue" 
			answer.append(["ENEMY_TURRON_REACT"])
			return answer
		"qwerty":
			answer[0] = "dialogue" 
			answer.append(["ENEMY_QWERTY_REACT"])
			return answer
		"joltest":
			answer[0] = "dialogue" 
			answer.append(["ENEMY_JOLTEST_REACT"])
			return answer
		"check":
			answer[0] = "dialogue_pass" 
			answer.append(["ENEMY_CHECK_REACT"])
			return answer
		"insult":
			answer[0] = "dialogue" 
			answer.append(["ENEMY_INSULT_REACT"])
			return answer
		"reason":
			answer[0] = "dialogue" 
			answer.append(["ENEMY_REASON_REACT"])
			return answer
		"attack":
			answer[0] = "dialogue" 
			answer.append(["ENEMY_INSULT_REACT"])
			return answer
	
	return answer

func take_hit(damage:int):
	hp-=damage
	$hp_bar/anim.play("simple_anim")
	$hp_bar/Label.text = str(damage)
	$hp_bar/smooth.interpolate_property($hp_bar, "value", $hp_bar.value, hp, 1)
	$hp_bar/smooth.start()

func start_dialogue(text = []):
	$dialogue.visible = true
	$dialogue.change_messages(text)
	$dialogue.start_dialogue()
	dialogue_active = true

func _on_dialogue_dialogue_ended():
	$dialogue.visible = false
	dialogue_active = false
