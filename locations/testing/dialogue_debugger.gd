extends Control

const translation_table := preload("res://languages/general_text.en.translation")
onready var key_list := $search_panel/VBoxContainer/ItemList

var uncompressed_dict := {}

func _ready():
	for key in translation_table.get_message_list():
		uncompressed_dict[key] = tr(key)
	show_full_list()

func show_full_list():
	key_list.clear()
	for key in uncompressed_dict:
		key_list.add_item(key)
	key_list.sort_items_by_text()

func _on_ItemList_item_activated(index):
	var key = key_list.get_item_text(index)
	$edit_panel/TextEdit.text = tr(key)
	_on_TextEdit_text_changed()


func _on_TextEdit_text_changed():
	var text = $edit_panel/TextEdit.text
	$dialogue_panel/DialogueLabel.messages = [text]
	$dialogue_panel/DialogueLabel.start_dialogue()


func _on_find_keys_pressed():
	key_list.clear()
	var search_word = $search_panel/VBoxContainer/LineEdit.text
	if search_word == "":
		show_full_list()
		return
	for key in uncompressed_dict:
		if search_word.to_lower() in key.to_lower():
			key_list.add_item(key)
	
	key_list.sort_items_by_text()

func _on_find_values_pressed():
	key_list.clear()
	var search_word = $search_panel/VBoxContainer/LineEdit.text
	if search_word == "":
		show_full_list()
		return
	for key in uncompressed_dict:
		if search_word.to_lower() in tr(key).to_lower():
			key_list.add_item(key)
	
	key_list.sort_items_by_text()
