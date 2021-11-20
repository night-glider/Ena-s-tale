extends KinematicBody

export var speed := 5
export var gravity := 1
export var mouse_sensitivity := 0.1

var velocity := Vector3.ZERO
var mouse_delta := Vector2.ZERO

func _physics_process(delta):
	var forward = -transform.basis.z
	var right = transform.basis.x
	velocity.x = 0
	velocity.z = 0
	
	if is_on_floor():
		velocity.y = -gravity
	else:
		velocity.y+= -gravity
	
	if Input.is_action_pressed("walk_forward"):
		velocity += forward * speed
	if Input.is_action_pressed("walk_backward"):
		velocity += -forward * speed
	
	if Input.is_action_pressed("walk_left"):
		velocity += -right * speed
	if Input.is_action_pressed("walk_right"):
		velocity += right * speed
	
	move_and_slide(velocity, Vector3.UP)

func _process(delta):
	$Camera.rotation_degrees.x -= mouse_delta.y * mouse_sensitivity
	rotation_degrees.y -= mouse_delta.x * mouse_sensitivity
	$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x,-90,90)
	
	mouse_delta = Vector2.ZERO
	
	if Input.is_action_just_pressed("mouse_mode"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
