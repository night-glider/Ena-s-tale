tool
extends Label

export var idle_color:Color = Color.white
export var active_color:Color = Color.yellow
export var disabled_color:Color = Color.darkgray
export var disabled:bool = false setget set_disabled
export(String, MULTILINE) var dialogue:String = "TEST_DIALOGUE"

signal pressed(id)
const pressed_sound = preload("res://sounds/select.ogg")
const active_sound = preload("res://sounds/squeak.ogg")

func set_disabled(value):
	disabled = value
	if disabled:
		self_modulate = disabled_color
	else:
		self_modulate = idle_color

func _ready():
	self_modulate = idle_color
	rect_size = Vector2.ZERO
	_on_Label_resized()

func press():
	if not disabled and is_visible_in_tree():
		emit_signal("pressed", self)
		Globals.play_sound(pressed_sound)

func _on_Area2D_area_entered(area):
	if not disabled:
		if area.is_in_group("player_hitbox"):
			if is_visible_in_tree():
				Globals.play_sound(active_sound)
			self_modulate = active_color

func _on_Area2D_area_exited(area):
	if not disabled:
		if area.is_in_group("player_hitbox"):
			self_modulate = idle_color

func _on_Label_resized():
	$Area2D/CollisionShape2D.shape.extents = rect_size/2 - Vector2(0,10)
	$Area2D.position = rect_size/2
