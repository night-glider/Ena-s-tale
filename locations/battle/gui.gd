extends Node2D


var active_button:int = 0
onready var buttons = [$strike, $talk, $pack]
enum stages {BOTTOM_BUTTONS, ITEMS_DIALOGUE, ITEMS}
var active_stage = stages.BOTTOM_BUTTONS

func items_stage():
	active_stage = stages.ITEMS
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(320,320)
	
	for element in $pack/inventory.get_children():
		element.visible = true

func bottom_buttons_stage():
	active_stage = stages.BOTTOM_BUTTONS
	$dialogue_box.change_size(Vector2(35,221), Vector2(571, 136))
	$player.position = Vector2(0,0)
	
	$dialogue_box/ReferenceRect/dialogue.visible = false
	for element in $pack/inventory.get_children():
		element.visible = false

func items_dialogue_stage(text:String):
	active_stage = stages.ITEMS_DIALOGUE
	$dialogue_box.start_dialogue(text)
	$player.position = Vector2(0,0)
	$pack/inventory
	
	for element in $pack/inventory.get_children():
		element.visible = false

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
		
		stages.ITEMS_DIALOGUE:
			if Input.is_action_just_pressed("interact"):
				bottom_buttons_stage()
		
		stages.ITEMS:
			if Input.is_action_pressed("cancel"):
				bottom_buttons_stage()

func _item_pressed(button):
	button.text = "-----"
	button.disabled = true
	items_dialogue_stage(button.dialogue)
	
