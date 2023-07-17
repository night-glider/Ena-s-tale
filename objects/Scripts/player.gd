extends KinematicBody

export var speed := 5.0
export var gravity := 0.5
export var mouse_sensitivity := 0.3
export var jump_force := 10.0
export var camera_wave_amplitude = 0.1
export var camera_wave_frequency = 0.1

var velocity := Vector3.ZERO
var mouse_delta := Vector2.ZERO
var can_control:bool = true
var camera_n:float = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var forward = -transform.basis.z
	var right = transform.basis.x
	velocity.x = 0
	velocity.z = 0
	
	if is_on_floor():
		velocity.y = -gravity
	else:
		velocity.y+= -gravity
	
	if can_control:
		if Input.is_action_pressed("walk_forward"):
			velocity += forward * speed
		if Input.is_action_pressed("walk_backward"):
			velocity += -forward * speed
		
		if Input.is_action_pressed("walk_left"):
			velocity += -right * speed
		if Input.is_action_pressed("walk_right"):
			velocity += right * speed
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_force
			$AudioStreamPlayer.play()
	
	if velocity.x != 0 or velocity.z != 0:
		$Camera.v_offset = sin(camera_n)*camera_wave_amplitude
		camera_n+=camera_wave_frequency
	else:
		$Camera.v_offset = lerp($Camera.v_offset, 0, 0.1)
		camera_n = 0#asin($Camera.v_offset)
	
	move_and_slide(velocity, Vector3.UP)

func _process(delta):
	if can_control:
		$Camera.rotation_degrees.x -= mouse_delta.y * mouse_sensitivity
		rotation_degrees.y -= mouse_delta.x * mouse_sensitivity
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x,-90,90)
	
	mouse_delta = Vector2.ZERO
	
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	
	if Input.is_action_just_pressed("interact") and can_control:
		for element in $interaction_zone.get_overlapping_bodies():
			if element.get_parent().get_parent().name == "moony":
				element.get_parent().get_parent().start_talking()
			if element.is_in_group("interactable"):
				can_control = false
				$gui.dialogue_start(element.get_parent().messages)
				return

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

func _on_GUI_dialogue_end():
	can_control = true


func _on_DialogueLabel_dialogue_custom_event(data):
	match data:
		"emote_sad":
			$gui/dialogue/DialogueLabel.ena_soundbyte = preload("res://sounds/ena_dialogue_sad.ogg")
		"emote_reset":
			$gui/dialogue/DialogueLabel.ena_soundbyte = preload("res://sounds/ena_dialogue.ogg")
