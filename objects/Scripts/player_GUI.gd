extends Control

signal dialogue_end
signal dialogue_next(dialogue)

export var text_speed:float = 0.5
export var max_distance = 60
export(Array, String, MULTILINE) var intro_messages
export(Array, Vector2) var intro_positions
export var intro_end_point = Vector3(0,0,0)


var current_messages:Array = []
var dialogue_active:bool = false
var visible_chars:float = 0
var intro_active = true

func _ready():
	for i in intro_messages.size():
		intro_messages[i] = tr(intro_messages[i])

func dialogue_start(messages:Array):
	dialogue_active = true
	$dialogue.visible = true
	$dialogue/DialogueLabel.change_messages(messages)
	$dialogue/DialogueLabel.start_dialogue()

func _process(delta):
	if intro_active:
		intro_process()
	
	if dialogue_active:
		if Input.is_action_just_pressed("interact"):
			if $dialogue/DialogueLabel.finished:
				$dialogue/DialogueLabel.next_message()
		if Input.is_action_just_pressed("cancel"):
			$dialogue/DialogueLabel.skip_message()

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

func _on_DialogueLabel_dialogue_ended():
	$dialogue.visible = false
	emit_signal("dialogue_end")
