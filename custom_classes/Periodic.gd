extends Node

class_name Periodic

func add_method(object:Object, method_name:String, args:Array, timing:float, delay:float = 0, destruction_time:float = 0):
	var new_timer:Timer = Timer.new()
	add_child(new_timer)
	if delay > 0:
		new_timer.start(delay)
		new_timer.wait_time = timing
	else:
		new_timer.wait_time = timing
		new_timer.start()
	
	new_timer.connect("timeout", object, method_name, args)
	
	if destruction_time > 0:
		destruction_time+=delay
		var destruction_timer:Timer = Timer.new()
		destruction_timer.one_shot = true
		add_child(destruction_timer)
		destruction_timer.connect("timeout", self, "_destroy_method", [new_timer, destruction_timer])
		destruction_timer.start(destruction_time)
	

func _destroy_method(timer:Timer, destruction_timer:Timer):
	timer.queue_free()
	destruction_timer.queue_free()
