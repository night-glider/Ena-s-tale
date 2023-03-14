extends Control

const select_sound = preload("res://sounds/select.ogg")

var options = []
var current_option = 0
var progress = 0

onready var general_options = [$general/continue, $general/options, $general/quit]
onready var options_options = [$options/master, $options/music, $options/sounds, $options/window, $options/back]

func increment_looping(val, start, finish):
	val+=0.1
	if val > finish:
		val = start
	return val


func _ready():
	options = general_options
	options[current_option].modulate = Color.yellow
	
	$options/master.text = tr("PAUSE_MASTER") + str(SaveData.load_data("master", 10))
	$options/music.text = tr("PAUSE_MUSIC") + str(SaveData.load_data("music", 10))
	$options/sounds.text = tr("PAUSE_SOUNDS") + str(SaveData.load_data("sound", 10))
	
	if OS.window_fullscreen:
		$options/window.text = tr("PAUSE_FULLSCREEN")
	else:
		$options/window.text = tr("PAUSE_WINDOW")

func _process(delta):
	if Input.is_action_pressed("pause"):
		progress+=1.0/180.0
	
	if progress > 1:
		progress = 0
		if visible:
			get_tree().paused = false
			visible = false
		else:
			get_tree().paused = true
			visible = true
	
	if not visible:
		return
	
	if Input.is_action_just_pressed("ui_down") and current_option < options.size()-1:
		options[current_option].modulate = Color.white
		current_option+=1
		options[current_option].modulate = Color.yellow
	if Input.is_action_just_pressed("ui_up") and current_option > 0:
		options[current_option].modulate = Color.white
		current_option-=1
		options[current_option].modulate = Color.yellow
	
	if Input.is_action_just_pressed("interact"):
		Globals.play_sound(select_sound)
		if options[current_option] == $general/continue:
			get_tree().paused = false
			visible = false
		
		
		if options[current_option] == $general/options:
			options[current_option].modulate = Color.white
			options = options_options
			$options.visible = true
			$general.visible = false
			
			current_option = 0
			options[current_option].modulate = Color.yellow
			return
		
		if options[current_option] == $options/back:
			options[current_option].modulate = Color.white
			options = general_options
			$options.visible = false
			$general.visible = true
			
			current_option = 0
			options[current_option].modulate = Color.yellow
			return
		
		if options[current_option] == $options/master:
			var volume = increment_looping(SaveData.load_data("master", 0.5), 0, 1)
			SaveData.save_data("master", volume)
			Globals.change_bus_volume("Master", volume)
			
			$options/master.text = tr("PAUSE_MASTER") + str(SaveData.load_data("master", 0.5) * 10)
		
		if options[current_option] == $options/music:
			var volume = increment_looping(SaveData.load_data("music", 0.5), 0, 1)
			SaveData.save_data("music",  volume)
			Globals.change_bus_volume("music", volume)
			$options/music.text = tr("PAUSE_MUSIC") + str(SaveData.load_data("music", 0.5) * 10)
		
		if options[current_option] == $options/sounds:
			var volume = increment_looping(SaveData.load_data("sound", 0.5), 0, 1)
			SaveData.save_data("sound", volume )
			Globals.change_bus_volume("sound", volume)
			$options/sounds.text = tr("PAUSE_SOUNDS") + str(SaveData.load_data("sound", 0.5) * 10)
		
		if options[current_option] == $options/window:
			OS.window_fullscreen = not OS.window_fullscreen
			if OS.window_fullscreen:
				$options/window.text = tr("PAUSE_FULLSCREEN")
			else:
				$options/window.text = tr("PAUSE_WINDOW")
		
		if options[current_option] == $general/quit:
			get_tree().quit()
