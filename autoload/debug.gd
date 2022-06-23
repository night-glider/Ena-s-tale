extends Node2D

var last_buttons = []
var cheat_activation = ["6","9","0","0","0","2","1"]
var dialog = preload("res://autoload/debug_popup.tscn")

func _ready():
	last_buttons = cheat_activation.duplicate()

func _input(event):
	if event is InputEventKey and event.pressed:
		for i in range(last_buttons.size()-1, 0, -1):
			last_buttons[i] = last_buttons[i-1]
		
		last_buttons[0] = OS.get_scancode_string(event.scancode)
		
		if last_buttons.hash() == cheat_activation.hash():
			var new_debug_menu = dialog.instance()
			get_tree().current_scene.add_child(new_debug_menu)
			new_debug_menu.call_deferred("popup")
			
			new_debug_menu.get_node("VBoxContainer/heal").connect("pressed", self, "_on_heal_pressed")
			new_debug_menu.get_node("VBoxContainer/attack_debugger").connect("pressed", self, "_on_attack_debugger_pressed")
			
			print("new debug menu instance created")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _on_attack_debugger_pressed():
	get_tree().change_scene("res://locations/testing/attacks_test.tscn")


func _on_heal_pressed():
	if get_tree().current_scene.name == "battle":
		get_tree().current_scene.get_node("gui/player").hp = 100
