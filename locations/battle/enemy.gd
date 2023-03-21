extends AnimatedSprite

const damage_sound = preload("res://sounds/damage.ogg")

var all_attacks = [2,3,4,5,6,7,8]
var current_attack_pool = []

var dialogue_active = false
var hp = 10000

var head_n = 0
var head_n_spd = PI/120.0

func head_animation():
	$head.position.y = 2 + sin(head_n) * 2
	head_n += head_n_spd

func _ready():
	for i in all_attacks.size():
		all_attacks[i] = load("res://objects/battle/attacks/attack{0}/attack{0}.tscn".format([all_attacks[i]]))
	
	current_attack_pool = all_attacks.duplicate()

func _process(delta):
	head_animation()
	
	if dialogue_active:
		if Input.is_action_just_pressed("interact"):
			if $dialogue.finished:
				$dialogue.next_message()
			else:
				pass
				#$dialogue.skip_message()
		
		if Input.is_action_pressed("cancel"):
			$dialogue.skip_message()

func choose_attack()->PackedScene:
	if current_attack_pool.empty():
		current_attack_pool = all_attacks.duplicate()
		current_attack_pool.shuffle()
	
	return current_attack_pool.pop_front()

func last_action_decision(action:String)->Array:
	if hp >= 10000:
		return ["dialogue_pass", ["ENEMY_INSULT_REACT"]]
	
	var answer = ["none"]
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
	answer = ["attack"]
	return answer

func take_hit(damage:int):
	hp-=damage
	$hp_bar/anim.play("simple_anim")
	$hp_bar/Label.text = str(damage)
	$hp_bar/smooth.interpolate_property($hp_bar, "value", $hp_bar.value, hp, 1)
	$hp_bar/smooth.start()
	if damage > 0:
		Globals.play_sound(damage_sound)

func start_dialogue(text = []):
	$dialogue.visible = true
	$dialogue.change_messages(text)
	$dialogue.start_dialogue()
	dialogue_active = true

func _on_dialogue_dialogue_ended():
	$dialogue.visible = false
	dialogue_active = false
