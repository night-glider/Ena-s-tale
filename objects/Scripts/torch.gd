extends OmniLight

var n = rand_range(0, 2 * PI)
export var n_spd = PI/60

export var min_energy:float = 5
export var max_energy:float = 7


var amplitude = 0
var center = 0

func _ready():
	amplitude = (max_energy - min_energy)/2
	center = max_energy - amplitude

func _process(delta):
	omni_range = center + sin(n) * amplitude
	n+=n_spd
