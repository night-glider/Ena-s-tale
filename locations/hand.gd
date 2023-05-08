extends AnimatedSprite

var destination = Vector2()
var stage = 0

func init(soul_pos:Vector2):
	destination = soul_pos
	position = destination + Vector2(50, 0)
	scale = Vector2.ONE * 0.75
	modulate.a = 0

func _process(delta):
	if stage == 0:
		position = lerp(position, destination, 0.025)
		scale.x = lerp(scale.x, 1, 0.025)
		scale.y = lerp(scale.y, 1, 0.025)
		modulate.a = lerp(modulate.a, 1, 0.025)
		if position.distance_to(destination) < 10:
			stage = 1
			get_node("../soul").modulate.a = 0
			animation = "fist"
			
			$Periodic.add_method(self, "shake", [], 0.01, 0, 0.2)
	

func shake():
	position = destination + Vector2(rand_range(-5, 5), rand_range(-5, 5))
