extends Control

var attack:Node

func _ready():
	$gui/dialogue_box.change_size(Vector2(320-13,240-13), Vector2(25,25))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	$gui/player.position.x = clamp($gui/player.position.x, $gui/dialogue_box.rect_position.x + 11, $gui/dialogue_box.rect_position.x + $gui/dialogue_box.rect_size.x - 11)
	$gui/player.position.y = clamp($gui/player.position.y, $gui/dialogue_box.rect_position.y + 11, $gui/dialogue_box.rect_position.y + $gui/dialogue_box.rect_size.y - 11)
	

func _on_SpinBox_value_changed(value):
	for element in $attack_gui/grid.get_children():
		element.queue_free()
	if ResourceLoader.exists("res://objects/battle/attacks/attack{0}/attack{0}.tscn".format([value])):
		$general/Button.disabled = false
		
		attack = load("res://objects/battle/attacks/attack{0}/attack{0}.tscn".format([value])).instance()
		$general/pos_x.text = str(attack.box_position.x)
		$general/pos_y.text = str(attack.box_position.y)
		$general/size_x.text = str(attack.box_size.x)
		$general/size_y.text = str(attack.box_size.y)
		
		for element in attack.get_property_list():
			if "export_" in element["name"]:
				var new_label:Label = Label.new()
				new_label.text = element["name"].trim_prefix("export_")
				new_label.autowrap = true
				new_label.rect_min_size.x = 125
				
				var new_line_edit = LineEdit.new()
				new_line_edit.rect_min_size.x = 125
				new_line_edit.text = str(attack.get(element["name"]))
				$attack_gui/grid.add_child(new_label)
				$attack_gui/grid.add_child(new_line_edit)
		
		attack.queue_free()
	else:
		$general/Button.disabled = true



func _on_Button_pressed():
	if $general/Button.text == "stop":
		$general/Button.text = "spawn"
		attack.queue_free()
		$attack_gui.visible = true
		return
	
	attack = load("res://objects/battle/attacks/attack{0}/attack{0}.tscn".format([$general/id.value])).instance()
	attack.box_position = Vector2(float($general/pos_x.text), float($general/pos_y.text))
	attack.box_size = Vector2(float($general/size_x.text), float($general/size_y.text))
	
	var var_name = ""
	for element in $attack_gui/grid.get_children():
		if element is Label:
			var_name = "export_" + element.text
		
		if element is LineEdit:
			if "(" in element.text:
				attack.set(var_name, Vector2.ZERO )
				continue
			if "." in element.text:
				attack.set(var_name, float(element.text))
				continue
			else:
				attack.set(var_name, int(element.text))
				continue
	
	$gui/dialogue_box.change_size(attack.box_position, attack.box_size)
	$gui.add_child(attack)
	attack.connect("attack_ended", self, "attack_ended")
	$attack_gui.visible = false
	$general/Button.text = "stop"

func attack_ended():
	$general/Button.text = "spawn"
	$attack_gui.visible = true
	$gui/dialogue_box.change_size(Vector2(320-13,240-13), Vector2(25,25))



func _on_copy_settings_pressed():
	var string = ""
	string += "attack_id: {0}\n\n".format( [$general/id.value] )
	string += "box_position: {0}, {1}\n".format( [$general/pos_x.text, $general/pos_y.text] )
	string += "box_position: {0}, {1}\n\n".format( [$general/size_x.text, $general/size_y.text] )
	
	for element in $attack_gui/grid.get_children():
		if element is Label:
			string += "export_" + element.text + " = "
		
		if element is LineEdit:
			string += element.text + "\n"
	OS.clipboard = string
