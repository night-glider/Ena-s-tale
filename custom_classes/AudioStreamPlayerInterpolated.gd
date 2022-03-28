extends AudioStreamPlayer
class_name AudioStreamPlayerInterpolated

export var delay : float = 1

var timer:Timer
var tween:Tween
var new_music:AudioStream
var transition_time:float

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", self, "_on_timer_timeout")
	
	tween = Tween.new()
	add_child(tween)
	
	#change_music(preload("res://OST/Kalimba.mp3"), 5)

func change_music(new_stream : AudioStream, delay:int = 5):
	transition_time = delay
	new_music = new_stream
	timer.start(5)
	
	tween.interpolate_property(self, "volume_db", volume_db, -40, transition_time)
	tween.start()


func _on_timer_timeout():
	stream = new_music
	play()
	tween.interpolate_property(self, "volume_db", volume_db, 0, transition_time)
	tween.start()
