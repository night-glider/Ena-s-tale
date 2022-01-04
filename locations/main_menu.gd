extends Control

var heart_pos:int = 0
var heart_poitions = []
var n = -9999
var active = true

func _ready():
	$menu/save1/Label.text = "[" + OS.get_environment("USERNAME") + "]"
	heart_poitions.append($menu/save1/heart_pos)
	heart_poitions.append($menu/save2/heart_pos)
	heart_poitions.append($menu/save3/heart_pos)
	heart_poitions.append($menu/lang/heart_pos)
	
	$AnimationPlayer.play("fade_in")

func _process(delta):
	$menu/heart/sprite.position.x = sin(n)*5
	n+=0.05
	
	if not active:
		return
	
	if Input.is_action_just_pressed("ui_up") and heart_pos > 0:
		heart_pos-=1
	if Input.is_action_just_pressed("ui_down") and heart_pos < 3:
		heart_pos+=1
	$menu/heart.global_position = heart_poitions[heart_pos].rect_global_position
	
	if Input.is_action_just_pressed("interact"):
		if heart_pos == 0:
			active = false
			$AnimationPlayer.play("fade_out")
		if heart_pos == 3:
			if $menu/lang.text == "ENGLISH":
				$menu/lang.text = "SPANISH"
			else:
				$menu/lang.text = "ENGLISH"


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene("res://locations/main.tscn")
