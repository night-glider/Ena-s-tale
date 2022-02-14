extends RichTextLabel
class_name RichTextLabelLocaled

func _ready():
	bbcode_text = tr(bbcode_text)

func change_text(new_text:String):
	bbcode_text = tr(new_text)
