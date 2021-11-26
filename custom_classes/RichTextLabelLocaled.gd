extends RichTextLabel
class_name RichTextLabelLocaled

func _ready():
	bbcode_text = tr(bbcode_text)
