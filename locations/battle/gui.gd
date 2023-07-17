extends Node2D

const select_sound = preload("res://sounds/select.ogg")
const active_sound = preload("res://sounds/squeak.ogg")
const ena_sad_soundbyte = preload("res://sounds/ena_dialogue_sad.ogg")
const ena_soundbyte = preload("res://sounds/ena_dialogue.ogg")
onready var dialogue_label = $dialogue

export var big_font:Font = null

var active_button:int = 0
onready var buttons = [$strike, $talk, $pack]
enum stages {
	BOTTOM_BUTTONS, 
	ITEMS, 
	ATTACK, 
	TALK, 
	GENERAL_DIALOGUE,
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

var reason_press_count = 0

var general_dialogue_next_stage = "ask_enemy"

var moony_cant_talk_triggered = false

func _ready():
	$enemy.player_data = $player
	$dialogue_box.start_inactive_dialogue("NARRATOR_BATTLE_DEFAULT_DIAL1")
	
	$player.change_stance($player.stances.SAD)
	$player.can_die = false

func narattor_light_progress():
	narrator_light_index = min(narrator_light_index+1, len(narrator_light_dials)-1)

func strike_stance_stage():
	active_stage = stages.STRIKE_STANCE
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(320,320)
	$strike/general_choice.visible = false
	$strike/stance_choice.visible = true

func strike_general_stage():
	Globals.play_sound(select_sound)
	active_stage = stages.STRIKE_GENERAL
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	#$dialogue_box.change_size(Vector2(97,221), Vector2(454, 136))
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
	#$dialogue_box.change_size(Vector2(97,221), Vector2(454, 136))
	$strike/general_choice.visible = false
	$strike/attack_choice.visible = true

func player_attack_stage(damage:int, difficulty:int):
	active_stage = stages.PLAYER_ATTACK
	#$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$dialogue_box.change_size(Vector2(97,221), Vector2(454, 124))
	$player.position = Vector2(0,0)
	last_action = "attack"
	
	$player.visible = false
	
	$strike/attack_choice.visible = false
	$dialogue_box/ReferenceRect/attack.visible = true
	$dialogue_box/ReferenceRect/attack.start_attack(5, damage, difficulty)

func talk_stage():
	if not talk_enabled:
		return
	Globals.play_sound(select_sound)
	active_stage = stages.TALK
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(320,290)
	
	$player.visible = true
	$bottom_ena.visible = false
	
	$talk/options.visible = true
	
	$dialogue_box.hide_dialogue()

func general_dialogue_stage():
	active_stage = stages.GENERAL_DIALOGUE
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(0,0)
	$player.visible = false
	$bottom_ena.visible = false
	
	$talk/options.visible = false
	$strike/attack_choice.visible = false
	$strike/general_choice.visible = false
	$pack/inventory.visible = false
	
	$dialogue_box.hide_dialogue()

func items_stage():
	Globals.play_sound(select_sound)
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
			if turns_passed < 2:
				narrator_line = "NARRATOR_BATTLE_DEFAULT_DIAL1"
			else:
				narrator_line = "NARRATOR_BATTLE_DEFAULT_DIAL2"
			
			if turns_passed == 2 and not moony_cant_talk_triggered:
				start_general_dialogue(
					["MOONY_BATTLE_CANTTALKMUCH_DIAL_1", 
					"MOONY_BATTLE_CANTTALKMUCH_DIAL_2"], 
					"menu")
				moony_cant_talk_triggered = true
				return
		routes.NEUTRAL:
			if turns_passed < 2:
				narrator_line = "NARRATOR_BATTLE_NEUTRAL_DIAL1"
			else:
				narrator_line = "NARRATOR_BATTLE_DEFAULT_DIAL2"
			
			if turns_passed == 2 and not moony_cant_talk_triggered:
				start_general_dialogue(
					["MOONY_BATTLE_CANTTALKMUCH_DIAL_1", 
					"MOONY_BATTLE_CANTTALKMUCH_DIAL_2"], 
					"menu")
				moony_cant_talk_triggered = true
				return
		routes.LIGHT:
			narrator_line = narrator_light_dials[narrator_light_index]
			
			if narrator_light_index == 4 and not moony_cant_talk_triggered:
				start_general_dialogue(
					["MOONY_BATTLE_CANTTALKMUCH_DIAL_1", 
					"MOONY_BATTLE_CANTTALKMUCH_DIAL_2"], 
					"menu")
				moony_cant_talk_triggered = true
				return
		
	$dialogue_box.start_inactive_dialogue(narrator_line)

func attack_stage():
	active_stage = stages.ATTACK
	var attack = $enemy.choose_attack().instance()
	attack.player = $player
	attack.enemy = $enemy
	attack.connect("attack_ended", self, "attack_ended")
	$dialogue_box.change_size(attack.box_position, attack.box_size)
	$player.position = Vector2(320,320)
	attack.name = "active_attack"
	add_child(attack)
	
	$player.can_regen = true
	$player.visible = true
	active_route = routes.NEUTRAL

func stop_attack():
	get_node("active_attack").queue_free()
	$enemy.toggle_default_animation()
	attack_ended()

func start_general_dialogue(dialogue:Array, next_stage:String="ask_enemy"):
	$dialogue.change_messages(dialogue)
	_on_dialogue_dialogue_next()
	$dialogue.start_dialogue()
	$dialogue.visible = true
	general_dialogue_stage()
	general_dialogue_next_stage = next_stage

func find_character_tag(message):
	var result = null
	for chr in message:
		if chr == "|":
			if result == null:
				result = ""
				continue
			else:
				return result
		
		if result != null:
			result += chr
	
	return result

func _on_dialogue_dialogue_ended():
	$dialogue.visible = false
	if general_dialogue_next_stage == "ask_enemy":
		ask_enemy_for_next_stage()
		return
	if general_dialogue_next_stage == "menu":
		bottom_buttons_stage()
		return
	if general_dialogue_next_stage == "attack":
		attack_stage()
		return

func _on_dialogue_dialogue_next():
	var tag = find_character_tag($dialogue.get_current_message())
	if tag == null:
		return
	
	if tag == "meist":
		$dialogue.add_font_override("normal_font", null)
		$dialogue/NinePatchRect.visible = true
		$dialogue.margin_left = 396+20
		$dialogue.margin_top = 91
		$dialogue.margin_right = 596-20
		$dialogue.margin_bottom = 108
	else:
		$dialogue.add_font_override("normal_font", big_font)
		$dialogue/NinePatchRect.visible = false
		$dialogue.margin_left = 45+20
		$dialogue.margin_top = 235
		$dialogue.margin_right = 597-20
		$dialogue.margin_bottom = 348

func _process(delta):
	match active_stage:
		stages.BOTTOM_BUTTONS:
			if Input.is_action_just_pressed("walk_left"):
				if active_button > 0:
					Globals.play_sound(active_sound)
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
					Globals.play_sound(active_sound)
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
		
		stages.GENERAL_DIALOGUE:
			if Input.is_action_just_pressed("interact"):
				if $dialogue.finished:
					$dialogue.next_message()
				else:
					pass
					#$dialogue.skip_message()
			
			if Input.is_action_pressed("cancel"):
				$dialogue.skip_message()
		
	
	
	
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
	#items_dialogue_stage(button.dialogue)
	start_general_dialogue([button.dialogue])
	last_action = button.name

func attack_ended():
	$player.change_mode(0)
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
			#enemy_dialogue_stage(result[1])
			start_general_dialogue(result[1], "attack")
			return
		"pass":
			bottom_buttons_stage()
			return
		"dialogue_pass":
			#enemy_dialogue_pass_stage(result[1])
			start_general_dialogue(result[1], "menu")
			return

func _on_player_attack_ended():
	#OS.alert("attack_ended with damage " + str(damage))
	ask_enemy_for_next_stage()

func _on_attack_damage_dealt(damage):
	$enemy.take_hit(damage)
	if damage == 0 and active_route == routes.LIGHT:
		narattor_light_progress()

func _on_attack_pressed(id):
	if $player.stance == $player.stances.RAGE:
		start_general_dialogue(["ENA_ATTACKS_RAGE"])
		return
	
	strike_limb_stage()

func _on_head_pressed(id):
	player_attack_stage($player.damage*2, 2)

func _on_torso_pressed(id):
	player_attack_stage($player.damage, 1)

func _on_legs_pressed(id):
	player_attack_stage($player.damage/2, 0)

func _on_infernal_pressed(id):
	last_action = "stance"
	$strike/stance_choice.visible = false
	
	start_general_dialogue([
		"ENA_RAGE_TRANSITION_DIAL_1",
		"ENA_RAGE_TRANSITION_DIAL_2"
		])
	#ask_enemy_for_next_stage()

func _on_glacial_pressed(id):
	last_action = "stance"
	$strike/stance_choice.visible = false
	
	start_general_dialogue([
		"ENA_SADNESS_TRANSITION_DIAL_1",
		"ENA_SADNESS_TRANSITION_DIAL_2"
		])
	#ask_enemy_for_next_stage()

func _on_stances_pressed(id):
	strike_stance_stage()

func _on_reason_pressed(id):
	var dialogue = []
	if $ena_status.current_state == "sad":
		if reason_press_count == 0:
			dialogue = [
				"ENA_TALK_REASON1_DIAL_1",
				"ENA_TALK_REASON1_DIAL_2",
				"ENA_TALK_REASON1_DIAL_3",
				"ENA_TALK_REASON1_DIAL_4",
				"ENA_TALK_REASON1_DIAL_5",
			]
		
		if reason_press_count == 1:
			dialogue = [
				"ENA_TALK_REASON2_DIAL_1",
				"ENA_TALK_REASON2_DIAL_2",
				"ENA_TALK_REASON2_DIAL_3",
				"ENA_TALK_REASON2_DIAL_4",
				"ENA_TALK_REASON2_DIAL_5",
				"ENA_TALK_REASON2_DIAL_6",
				"ENA_TALK_REASON2_DIAL_7"
			]
		
		if reason_press_count >= 2:
			dialogue = [
				"ENA_TALK_NEUTRAL_REASON1_DIAL_1"
			]
		
		if active_route == routes.NEUTRAL:
			dialogue = [
				"ENA_TALK_NEUTRAL_REASON1_DIAL_1"
			]
		
		reason_press_count += 1
	else:
		last_action = "reason_failed"
		dialogue = ["TALK_REASON_DIALOGUE_INACTIVE"]
	
	start_general_dialogue(dialogue)
	#talk_dialogue_stage(dialogue)
	last_action = id.name

func _on_insult_pressed(id):
	var dialogue
	if $ena_status.current_state == "sad":
		dialogue = ["TALK_INSULT_DIALOGUE_INACTIVE"]
	else:
		dialogue = ["TALK_INSULT_DIALOGUE"]
	start_general_dialogue(dialogue)
	last_action = id.name

func _on_player_got_hit(dmg):
	if active_stage == stages.ATTACK:
		if $player.hp <= 15:
			stop_attack()

func _on_dialogue_custom_event(data):
	match data:
		"emote_sad":
			$player.change_stance($player.stances.SAD)
		"emote_rage":
			$player.change_stance($player.stances.RAGE)
		"rage_strike":
			last_action = "attack"
			if randf() < 0.2:
				$enemy.take_hit(0)
			else:
				$enemy.take_hit(rand_range(300,1000))

func _on_player_stance_changed(new_stance):
	if new_stance == 1:
		dialogue_label.change_ena_soundbyte(ena_sad_soundbyte)
	else:
		dialogue_label.change_ena_soundbyte(ena_soundbyte)
