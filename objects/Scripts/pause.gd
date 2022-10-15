extends Control

var options = []
var current_option = 0

func increment_looping(val, start, finish):
	val+=1
	if val > finish:
		val = start
	return val


func _ready():
	options.append($continue)
	options.append($master)
	options.append($music)
	options.append($sounds)
	options.append($window)
	options.append($quit)
	options[current_option].modulate = Color.yellow
	
	$master.text = tr("PAUSE_MASTER") + str(SaveData.load_data("master", 10))
	$music.text = tr("PAUSE_MUSIC") + str(SaveData.load_data("music", 10))
	$sounds.text = tr("PAUSE_SOUNDS") + str(SaveData.load_data("sound", 10))
	
	if OS.window_fullscreen:
		$window.text = tr("PAUSE_FULLSCREEN")
	else:
		$window.text = tr("PAUSE_WINDOW")

func _process(delta):
	if Input.is_action_just_pressed("pause"):
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
		if options[current_option] == $continue:
			get_tree().paused = false
			visible = false
		
		if options[current_option] == $master:
			var volume = increment_looping(SaveData.load_data("master", 10), 0, 10)
			SaveData.save_data("master", volume)
			if volume == 0:
				AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
			else:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -40 + volume*4)
			
			$master.text = tr("PAUSE_MASTER") + str(SaveData.load_data("master", 10))
		
		if options[current_option] == $music:
			var volume = increment_looping(SaveData.load_data("music", 10), 0, 10)
			SaveData.save_data("music",  volume)
			if volume == 0:
				AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), true)
			else:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), -40 + volume*4)
			$music.text = tr("PAUSE_MUSIC") + str(SaveData.load_data("music", 10))
		
		if options[current_option] == $sounds:
			var volume = increment_looping(SaveData.load_data("sound", 10), 0, 10)
			SaveData.save_data("sound", volume )
			if volume == 0:
				AudioServer.set_bus_mute(AudioServer.get_bus_index("sound"), true)
			else:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sound"), -40 + volume*4)
			$sounds.text = tr("PAUSE_SOUND") + str(SaveData.load_data("sound", 10))
		
		if options[current_option] == $window:
			OS.window_fullscreen = not OS.window_fullscreen
			if OS.window_fullscreen:
				$window.text = tr("PAUSE_FULLSCREEN")
			else:
				$window.text = tr("PAUSE_WINDOW")
		
		if options[current_option] == $quit:
			get_tree().quit()
