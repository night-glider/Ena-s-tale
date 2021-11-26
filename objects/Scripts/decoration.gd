extends AnimatedSprite3D


export(Array, String) var messages

func _ready():
	for i in messages.size():
		messages[i] = tr(messages[i])
