extends RichTextLabel
class_name DialogueLabel

export(Array, String, MULTILINE) var messages:Array = ["HELLO_WORLD"]
export var finished = false

signal dialogue_started
signal dialogue_next
signal dialogue_ended

var timer:Timer = Timer.new()
var message_id:int = 0
var char_progress = 0


#audio thingies
var audio_player = AudioStreamPlayer.new()
const meist_soundbyte = preload("res://sounds/meist_dialogue.ogg")
const moony_soundbyte = preload("res://sounds/moony_dialogue.ogg")

func _init():
	bbcode_enabled = true
	scroll_active = false
	

func _ready():
	add_child(timer)
	add_child(audio_player)
	timer.wait_time = 0.1
	timer.connect("timeout", self, "next_symbol")
	
	if messages.empty():
		assert(false, "DialogueLabel's messages are empty!")
	
	for i in messages.size():
		if messages[i] == tr(messages[i]):
			assert(false, "missing " + messages[i] + " translation!")
		else:
			messages[i] = tr(messages[i])


func change_messages(new_array:Array):
	messages = new_array.duplicate()
	if messages.empty():
		assert(false, "DialogueLabel's messages are empty!")
	
	
	for i in messages.size():
		if messages[i] == tr(messages[i]):
			assert(false, "missing " + messages[i] + " translation!")
		else:
			messages[i] = tr(messages[i])

func start_dialogue():
	message_id = 0
	char_progress = 0
	finished = false
	
	bbcode_text = ""
	next_symbol()
	timer.start()
	emit_signal("dialogue_started")

func next_message():
	bbcode_text = ""
	message_id+=1
	char_progress = 0
	finished = false
	
	if message_id < messages.size():
		next_symbol()
		timer.start()
		emit_signal("dialogue_next")
	else:
		emit_signal("dialogue_ended")

func skip_message():
	if message_id >= len(messages):
		return
	timer.stop()
	while char_progress < messages[message_id].length():
		next_symbol()
	finished = true

func next_symbol():
	if message_id >= messages.size():
		return
	
	if char_progress == messages[message_id].length():
		timer.stop()
		finished = true
		return
	
	if(messages[message_id][char_progress] == "["):
		while(messages[message_id][char_progress] != "]"):
			bbcode_text+=messages[message_id][char_progress]
			char_progress+=1
		bbcode_text+=messages[message_id][char_progress]
		char_progress+=1
		return
	
	if(messages[message_id][char_progress] == "%"):
		char_progress+=1
		while(messages[message_id][char_progress] != "%"):
			bbcode_text+=messages[message_id][char_progress]
			char_progress+=1
		char_progress+=1
		return
	
	if(messages[message_id][char_progress] == "@"):
		char_progress+=1
		var new_str = ""
		while(messages[message_id][char_progress] != "@"):
			new_str+=messages[message_id][char_progress]
			char_progress+=1
		timer.wait_time = float(new_str)
		timer.start(timer.wait_time)
		char_progress+=1
		return
	
	if(messages[message_id][char_progress] == "|"):
		char_progress+=1
		var new_str = ""
		while(messages[message_id][char_progress] != "|"):
			new_str+=messages[message_id][char_progress]
			char_progress+=1
		
		if new_str == "meist":
			audio_player.stream = meist_soundbyte
		elif new_str == "moony":
			audio_player.stream = moony_soundbyte
		elif new_str == "":
			audio_player.stream = null
		
		char_progress+=1
		return
	
	var new_char = messages[message_id][char_progress]
	bbcode_text+=new_char
	audio_player.play()
	
	if new_char == ",":
		var timer_old_time = timer.wait_time
		timer.start(0.5)
		timer.wait_time = timer_old_time
	
	char_progress+=1
	return
