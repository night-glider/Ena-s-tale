extends Node2D


var active_button:int = 0
onready var buttons = [$strike, $talk, $pack]
enum stages {
	BOTTOM_BUTTONS, 
	ITEMS_DIALOGUE, 
	ITEMS, 
	ATTACK, 
	TALK, 
	TALK_DIALOGUE, 
	ENEMY_DIALOGUE, 
	ENEMY_DIALOGUE_PASS,
	PLAYER_ATTACK,
	STRIKE_GENERAL,
	STRIKE_LIMB
	}
var active_stage = stages.BOTTOM_BUTTONS
var last_action = ""

func strike_general_stage():
	active_stage = stages.STRIKE_GENERAL
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(320,320)
	$strike/general_choice.visible = true

func strike_limb_stage():
	active_stage = stages.STRIKE_LIMB
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$strike/general_choice.visible = false
	$strike/attack_choice.visible = true

func player_attack_stage(damage:int):
	active_stage = stages.PLAYER_ATTACK
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(0,0)
	last_action = "attack"
	
	$strike/attack_choice.visible = false
	$dialogue_box/ReferenceRect/attack.visible = true
	$dialogue_box/ReferenceRect/attack.start_attack(5, damage)

func enemy_dialogue_stage(dialogue = []):
	active_stage = stages.ENEMY_DIALOGUE
	$enemy.start_dialogue(dialogue)
	$player.position = Vector2(0,0)

func enemy_dialogue_pass_stage(dialogue = []):
	active_stage = stages.ENEMY_DIALOGUE_PASS
	$enemy.start_dialogue(dialogue)
	$player.position = Vector2(0,0)

func talk_stage():
	active_stage = stages.TALK
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(320,320)
	
	$talk/options.visible = true

func talk_dialogue_stage(text:String):
	active_stage = stages.TALK_DIALOGUE
	$dialogue_box.start_dialogue(text)
	$player.position = Vector2(0,0)
	
	$talk/options.visible = false

func items_stage():
	active_stage = stages.ITEMS
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(320,320)
	
	$pack/inventory.visible = true

func bottom_buttons_stage():
	active_stage = stages.BOTTOM_BUTTONS
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(0,0)
	
	$dialogue_box/ReferenceRect/dialogue.visible = false
	$pack/inventory.visible = false
	$talk/options.visible = false

func items_dialogue_stage(text:String):
	active_stage = stages.ITEMS_DIALOGUE
	$dialogue_box.start_dialogue(text)
	$player.position = Vector2(0,0)
	
	$pack/inventory.visible = false

func attack_stage():
	active_stage = stages.ATTACK
	var attack = preload("res://objects/battle/attacks/attack1/attack1.tscn").instance()
	attack.connect("attack_ended", self, "attack_ended")
	$dialogue_box.change_size(attack.box_position, attack.box_size)
	$player.position = Vector2(320,320)
	add_child(attack)

func _process(delta):
	match active_stage:
		stages.BOTTOM_BUTTONS:
			if Input.is_action_just_pressed("walk_left"):
				if active_button > 0:
					buttons[active_button].animation = "idle"
					active_button-=1
					buttons[active_button].animation = "active"
			
			if Input.is_action_just_pressed("walk_right"):
				if active_button < 2:
					buttons[active_button].animation = "idle"
					active_button+=1
					buttons[active_button].animation = "active"
			
			if Input.is_action_just_pressed("interact"):
				if buttons[active_button] == $pack:
					items_stage()
				if buttons[active_button] == $strike:
					strike_general_stage()
				if buttons[active_button] == $talk:
					talk_stage()
		
		stages.ITEMS_DIALOGUE:
			pass
		
		stages.ITEMS:
			if Input.is_action_pressed("cancel"):
				bottom_buttons_stage()
		
		stages.TALK:
			if Input.is_action_just_pressed("cancel"):
				bottom_buttons_stage()
		
		stages.TALK_DIALOGUE:
			pass
		
		stages.ENEMY_DIALOGUE:
			pass
	
	$bottom_panel/hp_bar.value = $player.hp
	$bottom_panel/hp.text = "{0}/100".format([$player.hp])

func _item_pressed(button):
	button.text = "-----"
	button.disabled = true
	items_dialogue_stage(button.dialogue)
	
	$player.heal(25)
	
	last_action = button.name

func _on_dialogue_dialogue_ended():
	if active_stage == stages.ITEMS_DIALOGUE:
		ask_enemy_for_next_stage()
	if active_stage == stages.TALK_DIALOGUE:
		ask_enemy_for_next_stage()

func _on_check_pressed(id):
	talk_dialogue_stage(id.dialogue)
	last_action = id.name

func attack_ended():
	bottom_buttons_stage()

func ask_enemy_for_next_stage():
	var result = $enemy.last_action_decision(last_action)
	# "attack"
	# "dialogue"
	# "pass"
	# "dialogue_pass" - shows dialogue and then 
	# does not attack
	match result[0]:
		"attack": 
			attack_stage()
			return
		"dialogue":
			enemy_dialogue_stage(result[1])
			return
		"pass":
			bottom_buttons_stage()
			return
		"dialogue_pass":
			enemy_dialogue_pass_stage(result[1])
			return

func _on_enemy_dialogue_ended():
	if active_stage == stages.ENEMY_DIALOGUE:
		attack_stage()
	if active_stage == stages.ENEMY_DIALOGUE_PASS:
		bottom_buttons_stage()

func _on_player_attack_ended(damage):
	OS.alert("attack_ended with damage " + str(damage))
	$enemy.take_hit(damage)
	ask_enemy_for_next_stage()


func _on_attack_pressed(id):
	strike_limb_stage()


func _on_head_pressed(id):
	player_attack_stage(4000)


func _on_torso_pressed(id):
	player_attack_stage(2000)


func _on_legs_pressed(id):
	player_attack_stage(1000)
