extends Control

func start_dialogue(text):
	$ReferenceRect/dialogue.visible = true
	$ReferenceRect/dialogue.change_text(text)


func change_size(new_pos:Vector2, new_size:Vector2):
	$Tween.interpolate_property(self, "rect_position", rect_position, new_pos, 1)
	$Tween.interpolate_property(self, "rect_size", rect_size, new_size, 1)
	$Tween.start()


