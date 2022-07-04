tool
extends EditorPlugin

func _enter_tree():
	add_tool_menu_item("Translation Check", self, "check_translation")

func _exit_tree():
	remove_tool_menu_item("Translation Check")

func check_translation(args):
	var all_keys_in_scenes:Array = []
	var all_keys_in_scenes_paths:Array = []
	var all_keys_in_translation:Array = []
	
	var regex = RegEx.new()
	regex.compile("\"[A-Z_][A-Z0-9_]{1,100}\"")
	var files_list:Array = get_all_files("res://")
	for element in files_list:
		#print(element)
		var file = File.new()
		file.open(element, File.READ)
		var content = file.get_as_text()
		file.close()
		
		var result:Array = regex.search_all(content)
		for matches in result:
			all_keys_in_scenes.append( matches.get_string().rstrip("\"").lstrip("\"") )
			all_keys_in_scenes_paths.append(element)
	
	var file := File.new()
	file.open("res://languages/general_text.csv", File.READ)
	file.get_csv_line()
	while file.get_position() < file.get_len():
		all_keys_in_translation.append( file.get_csv_line()[0] )
	
	#print(all_keys_in_scenes)
	#print(all_keys_in_translation)
	var error_message:String = ""
	for i in all_keys_in_scenes.size():
		if not all_keys_in_scenes[i] in all_keys_in_translation:
			error_message += ("ERROR KEY DOES NOT EXITS: " + all_keys_in_scenes[i]) + "\n"
			error_message += ("PATH: " + all_keys_in_scenes_paths[i]) + "\n\n"
	
	for element in all_keys_in_translation:
		if not element in all_keys_in_scenes:
			error_message += ("KEY " + element + " EXISTS BUT IS NOT USED" ) + "\n"
	
	error_message += check_name_tag()
	
	print(error_message)
	OS.alert(error_message)


func get_all_files(path: String):
	var dir = Directory.new()
	var result:Array = []
	
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				result.append_array( get_all_files(dir.get_current_dir().plus_file(file_name) ) )
			else:
				if file_name.get_extension() in ["tscn", "gd"]:
					result.append( dir.get_current_dir().plus_file(file_name) )
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access %s." % path)
	return result

func check_name_tag():
	var errors = ""
	var allowed_names = ["", "meist", "moony"]
	
	var regex = RegEx.new()
	regex.compile("\\|(.{0,})\\|")
	
	var file:File = File.new()
	file.open("res://languages/general_text.csv", File.READ)
	file.get_csv_line()
	while file.get_position() < file.get_len():
		var lines = file.get_csv_line()
		for line in lines:
			var results = regex.search_all( line )
			for element in results:
				var name = element.strings[1]
				if not ( name in allowed_names ):
					errors += "incorrect name '" + name + "' in line '" + line + "'"
	
	return errors
