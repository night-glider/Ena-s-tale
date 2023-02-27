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
	STRIKE_LIMB,
	STRIKE_STANCE
	}
var active_stage = stages.BOTTOM_BUTTONS
var last_action = ""
var next_attack = null
enum routes {
	NONE,
	LIGHT,
	NEUTRAL,
}
var active_route = routes.LIGHT

var narrator_light_dials = [
	"NARRATOR_BATTLE_LIGHT_DIAL1",
	"NARRATOR_BATTLE_LIGHT_DIAL2",
	"NARRATOR_BATTLE_LIGHT_DIAL3",
	"NARRATOR_BATTLE_LIGHT_DIAL4",
	"NARRATOR_BATTLE_LIGHT_DIAL5",
	"NARRATOR_BATTLE_LIGHT_DIAL6",
	"NARRATOR_BATTLE_LIGHT_DIAL7",
	"NARRATOR_BATTLE_LIGHT_DIAL8",
]
var narrator_light_index = 0

var talk_enabled = false
var turns_passed = 0

func narattor_light_progress():
	narrator_light_index = min(narrator_light_index+1, len(narrator_light_dials)-1)

func strike_stance_stage():
	active_stage = stages.STRIKE_STANCE
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(320,320)
	$strike/general_choice.visible = false
	$strike/stance_choice.visible = true

func strike_general_stage():
	active_stage = stages.STRIKE_GENERAL
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(320,260)
	$strike/attack_choice.visible = false
	$strike/stance_choice.visible = false
	$strike/general_choice.visible = true
	
	$player.visible = true
	$bottom_ena.visible = false
	
	$dialogue_box.hide_dialogue()

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
	
	$player.visible = false
	
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
	if not talk_enabled:
		return
	
	active_stage = stages.TALK
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(260,290)
	
	$player.visible = true
	$bottom_ena.visible = false
	
	$talk/options.visible = true
	
	$dialogue_box.hide_dialogue()

func talk_dialogue_stage(text:String):
	active_stage = stages.TALK_DIALOGUE
	$dialogue_box.start_dialogue(text)
	$player.position = Vector2(0,0)
	
	$player.visible = false
	
	$talk/options.visible = false

func items_stage():
	active_stage = stages.ITEMS
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(320,320)
	
	
	$bottom_ena.visible = false
	
	$pack/inventory.visible = true
	
	$player.visible = true
	
	$dialogue_box.hide_dialogue()

func bottom_buttons_stage():
	active_stage = stages.BOTTOM_BUTTONS
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(0,0)
	
	$player.can_regen = false
	$player.visible = false
	$bottom_ena.visible = true
	
	$strike/general_choice.visible = false
	$dialogue_box/ReferenceRect/dialogue.visible = false
	$pack/inventory.visible = false
	$talk/options.visible = false
	
	var narrator_line
	match active_route:
		routes.NONE:
			narrator_line = "NARRATOR_BATTLE_DEFAULT_DIAL1"
		routes.NEUTRAL:
			narrator_line = "NARRATOR_BATTLE_NEUTRAL_DIAL1"
		routes.LIGHT:
			narrator_line = narrator_light_dials[narrator_light_index]
		
	$dialogue_box.start_inactive_dialogue(narrator_line)

func items_dialogue_stage(text:String):
	active_stage = stages.ITEMS_DIALOGUE
	$dialogue_box.start_dialogue(text)
	$player.position = Vector2(0,0)
	
	$player.visible = false
	
	$pack/inventory.visible = false

func attack_stage():
	active_stage = stages.ATTACK
	var attack = $enemy.choose_attack().instance()
	attack.connect("attack_ended", self, "attack_ended")
	$dialogue_box.change_size(attack.box_position, attack.box_size)
	$player.position = Vector2(320,320)
	add_child(attack)
	
	$player.can_regen = true
	$player.visible = true
	active_route = routes.NEUTRAL

func _process(delta):
	match active_stage:
		stages.BOTTOM_BUTTONS:
			if Input.is_action_just_pressed("walk_left"):
				if active_button > 0:
					buttons[active_button].animation = "idle"
					active_button-=1
					buttons[active_button].animation = "active"
				
					if not talk_enabled:
						if $talk.animation == "idle":
							$talk.animation = "idle_disabled"
						else:
							$talk.animation = "active_disabled"
			
			if Input.is_action_just_pressed("walk_right"):
				if active_button < 2:
					buttons[active_button].animation = "idle"
					active_button+=1
					buttons[active_button].animation = "active"
					
					if not talk_enabled:
						if $talk.animation == "idle":
							$talk.animation = "idle_disabled"
						else:
							$talk.animation = "active_disabled"
			
			if Input.is_action_just_pressed("interact"):
				if buttons[active_button] == $pack:
					items_stage()
				if buttons[active_button] == $strike:
					strike_general_stage()
				if buttons[active_button] == $talk:
					talk_stage()
			
			$bottom_ena.position.x = buttons[active_button].position.x - 50
			$bottom_ena.position.y = buttons[active_button].position.y
		
		stages.ITEMS:
			if Input.is_action_pressed("cancel"):
				bottom_buttons_stage()
		
		stages.TALK:
			if Input.is_action_just_pressed("cancel"):
				bottom_buttons_stage()
		
		stages.STRIKE_GENERAL:
			if Input.is_action_just_pressed("cancel"):
				bottom_buttons_stage()
		
		stages.STRIKE_LIMB:
			if Input.is_action_just_pressed("cancel"):
				strike_general_stage()
		
		stages.STRIKE_STANCE:
			if Input.is_action_just_pressed("cancel"):
				strike_general_stage()
	
	$player.position.x = clamp($player.position.x, $dialogue_box.rect_position.x + 11, $dialogue_box.rect_position.x + $dialogue_box.rect_size.x - 11)
	$player.position.y = clamp($player.position.y, $dialogue_box.rect_position.y + 11, $dialogue_box.rect_position.y + $dialogue_box.rect_size.y - 11)
	
	$bottom_panel/hp_bar.value = $player.hp
	$bottom_panel/hp.text = "{0}/100".format([$player.hp])

func _item_pressed(button):
	match button.text:
		"ITEMS_TURRON": $player.heal(30, [25,20,15,10])
		"ITEMS_SOLQUICHE": $player.heal(10, [20, 15, 5])
		"ITEMS_BANANA": $player.heal(5, [10,5,3,2])
	
	button.text = "-----"
	button.disabled = true
	items_dialogue_stage(button.dialogue)
	
	last_action = button.name

func _on_dialogue_dialogue_ended():
	if active_stage == stages.ITEMS_DIALOGUE:
		ask_enemy_for_next_stage()
	if active_stage == stages.TALK_DIALOGUE:
		ask_enemy_for_next_stage()

func attack_ended():
	bottom_buttons_stage()

func ask_enemy_for_next_stage():
	turns_passed+=1
	if turns_passed == 5:
		talk_enabled = true
		$talk.animation = "idle"
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

func _on_player_attack_ended():
	#OS.alert("attack_ended with damage " + str(damage))
	ask_enemy_for_next_stage()

func _on_attack_damage_dealt(damage):
	$enemy.take_hit(damage)
	if damage == 0 and active_route == routes.LIGHT:
		narattor_light_progress()

func _on_attack_pressed(id):
	strike_limb_stage()

func _on_head_pressed(id):
	player_attack_stage($player.damage*2)

func _on_torso_pressed(id):
	player_attack_stage($player.damage)

func _on_legs_pressed(id):
	player_attack_stage($player.damage/2)

	last_action = "stance"
	$player.change_stance($player.stances.NORMAL)
	$strike/stance_choice.visible = false
	ask_enemy_for_next_stage()

func _on_infernal_pressed(id):
	last_action = "stance"
	$player.change_stance($player.stances.RAGE)
	$strike/stance_choice.visible = false
	ask_enemy_for_next_stage()

func _on_glacial_pressed(id):
	last_action = "stance"
	$player.change_stance($player.stances.SAD)
	$strike/stance_choice.visible = false
	ask_enemy_for_next_stage()

func _on_stances_pressed(id):
	strike_stance_stage()


func _on_reason_pressed(id):
	var dialogue
	if $ena_status.current_state == "sad":
		dialogue = "TALK_REASON_DIALOGUE"
	else:
		dialogue = "TALK_REASON_DIALOGUE_INACTIVE"
	talk_dialogue_stage(dialogue)
	last_action = id.name
	

func _on_insult_pressed(id):
	var dialogue
	if $ena_status.current_state == "sad":
		dialogue = "TALK_INSULT_DIALOGUE_INACTIVE"
	else:
		dialogue = "TALK_INSULT_DIALOGUE"
	talk_dialogue_stage(dialogue)
	last_action = id.name
