extends Control


func _ready():
	$RichTextLabel2.bbcode_text = Globals.error_message

func _on_Timer_timeout():
	get_tree().quit()
