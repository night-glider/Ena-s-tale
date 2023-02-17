extends Node2D

var velocity := Vector2.ZERO
var damage := 0


func init(pos:Vector2, target:Vector2, spd=2, dmg=0):
	damage = dmg
	position = pos
	velocity = position.direction_to(target) * spd
	

func _process(delta):
	position += velocity
