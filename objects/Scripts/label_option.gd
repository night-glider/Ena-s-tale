tool
extends Control

export var idle_color:Color = Color.white
export var active_color:Color = Color.yellow
export var disabled_color:Color = Color.darkgray
export var disabled:bool = false setget set_disabled
export(String, MULTILINE) var dialogue:String = "TEST_DIALOGUE"

signal pressed(id)

func set_disabled(value):
	disabled = value
	if disabled:
		self_modulate = disabled_color
	else:
		self_modulate = idle_color

func _ready():
	self_modulate = idle_color
	$Area2D/CollisionShape2D.shape.extents = rect_size/2
	$Area2D.position = rect_size/2

func press():
	if not disabled and visible:
		emit_signal("pressed", self)

func _on_Area2D_area_entered(area):
	if not disabled:
		if area.is_in_group("player_hitbox"):
			self_modulate = active_color

func _on_Area2D_area_exited(area):
	if not disabled:
		if area.is_in_group("player_hitbox"):
			self_modulate = idle_color

func _on_Label_resized():
	$Area2D/CollisionShape2D.shape.extents = rect_size/2
	$Area2D.position = rect_size/2
