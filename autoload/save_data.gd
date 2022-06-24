extends Node

var config:ConfigFile = ConfigFile.new()

func _ready():
	config.load_encrypted_pass("user://save_data.cfg", "try_to_guess_this_password")
	
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			print(section)
			print("\t"+key)
			print("\t\t" + str(config.get_value(section, key, "NO VALUE")))
	
	save_data("game_opened", load_data("game_opened", 0)+1 )

func load_data(var_name, default):
	return config.get_value("savedata", var_name, default)

func save_data(var_name, value):
	config.set_value("savedata", var_name, value)
	config.save_encrypted_pass("user://save_data.cfg", "try_to_guess_this_password")

func clear_data():
	config.clear()
	config.save_encrypted_pass("user://save_data.cfg", "try_to_guess_this_password")
