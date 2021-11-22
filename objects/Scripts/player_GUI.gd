extends Control

signal dialogue_end

export var text_speed:float = 0.5

var current_messages:Array = []
var dialogue_active:bool = false
var visible_chars:float = 0

func dialogue_start(messages:Array):
	dialogue_active = true
	current_messages = messages.duplicate()
	$dialogue/RichTextLabel.bbcode_text = current_messages.pop_front()
	$dialogue/RichTextLabel.percent_visible = 0
	$dialogue.visible = true
	visible_chars = 0

func dialogue_next():
	if current_messages.size() == 0:
		$dialogue.visible = false
		dialogue_active = false
		visible_chars = 0
		emit_signal("dialogue_end")
		return
	
	$dialogue/RichTextLabel.bbcode_text = current_messages.pop_front()
	$dialogue/RichTextLabel.percent_visible = 0
	visible_chars = 0

func _process(delta):
	if dialogue_active:
		if Input.is_action_just_pressed("interact") and $dialogue/RichTextLabel.visible_characters > 2:
			if $dialogue/RichTextLabel.percent_visible < 1:
				visible_chars = 900
			else:
				dialogue_next()
		
		visible_chars+=text_speed
		$dialogue/RichTextLabel.visible_characters = visible_chars
