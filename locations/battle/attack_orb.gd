extends Node2D

var target := Vector2.ZERO
enum behaviors {LINEAR = 0, LERP = 1, SPRIRAL = 2}
var behavior = behaviors.LINEAR
var spd = 2
var lerp_k = 0.05
var spiral_r = 0
var spiral_n = 0


func init(tar:Vector2, behave = "random"):
	target = tar
	match behave:
		"linear": behavior = behaviors.LINEAR
		"lerp": behavior = behaviors.LERP
		"spiral": behavior = behaviors.SPRIRAL
		"random": behavior = randi()%3
	spiral_n = rand_range(-PI, PI)
	spiral_r = 100

func _process(delta):
	match behavior:
		behaviors.LINEAR:
			position = position.move_toward( target, spd)
		behaviors.LERP:
			position = lerp(position, target, lerp_k)
		behaviors.SPRIRAL:
			position.x = target.x + cos(spiral_n) * spiral_r
			position.y = target.y + sin(spiral_n) * spiral_r
			spiral_r -= 0.5
			spiral_n += PI/60

