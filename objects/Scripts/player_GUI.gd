extends Control

signal dialogue_end

export var text_speed:float = 0.5
export var max_distance = 60
export(Array, String, MULTILINE) var intro_messages
export(Array, Vector2) var intro_positions
export var intro_end_point = Vector3(0,0,0)


var current_messages:Array = []
var dialogue_active:bool = false
var visible_chars:float = 0
var intro_active = true

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
	if intro_active:
		intro_process()
	
	if dialogue_active:
		if Input.is_action_just_pressed("interact") and $dialogue/RichTextLabel.visible_characters > 2:
			if $dialogue/RichTextLabel.percent_visible < 1:
				visible_chars = 900
			else:
				dialogue_next()
		
		visible_chars+=text_speed
		$dialogue/RichTextLabel.visible_characters = visible_chars

func intro_process():
	var distance = get_parent().global_transform.origin.distance_to(intro_end_point)
	if get_parent().global_transform.origin.z < 0:
		intro_active = false
		$intro.visible = false
	if distance > max_distance:
		$intro.bbcode_text = ""
	else:
		var index = intro_messages.size() - (distance / max_distance) * intro_messages.size()
		$intro.bbcode_text = intro_messages[index]
		$intro.anchor_left = intro_positions[index].x
		$intro.anchor_top = intro_positions[index].y
		$intro.anchor_right = $intro.anchor_left
		$intro.anchor_bottom = $intro.anchor_top
		var percent = ( (distance / max_distance) * intro_messages.size() )
		while percent > 1:
			percent-=1
		percent = 1 - percent
		if percent < 0.5:
			$intro.modulate.a = percent*2
		else:
			$intro.modulate.a = 1 - (percent - 0.5)*2
		
		
		
	
