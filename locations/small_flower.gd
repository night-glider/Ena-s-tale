tool
extends Sprite3D

export var shuffle_color := false setget set_shuffle_color
export var shuffle_position := false setget set_shuffle_position

func set_shuffle_color(val):
	frame = rand_range(0,11)

func set_shuffle_position(val):
	translation.x += rand_range(-1,1)
	translation.z += rand_range(-1,1)
