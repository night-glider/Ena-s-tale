extends Control

var active = false

func start_dialogue(text):
	active = true
	$ReferenceRect/dialogue.visible = true
	$ReferenceRect/dialogue.change_messages( [text] )
	$ReferenceRect/dialogue.start_dialogue()

func start_inactive_dialogue(text):
	$ReferenceRect/dialogue.visible = true
	$ReferenceRect/dialogue.change_messages( [text] )
	$ReferenceRect/dialogue.start_dialogue()

func hide_dialogue():
	$ReferenceRect/dialogue.visible = false

func change_size(new_pos:Vector2, new_size:Vector2):
	$Tween.interpolate_property(self, "rect_position", rect_position, new_pos, 1)
	$Tween.interpolate_property(self, "rect_size", rect_size, new_size, 1)
	$Tween.start()


func _process(delta):
	if active:
		if Input.is_action_just_pressed("interact"):
			if $ReferenceRect/dialogue.finished:
				$ReferenceRect/dialogue.next_message()
			else:
				$ReferenceRect/dialogue.skip_message()
		
		if Input.is_action_pressed("cancel"):
			$ReferenceRect/dialogue.skip_message()


func _on_dialogue_dialogue_ended():
	active = false
