extends Control

var head_n = 0
var head_n_spd = PI/120.0

func head_animation():
	$gui/enemy/head.position.y = 3 + sin(head_n) * 3
	head_n += head_n_spd

func _ready():
	$AnimationPlayer.play("start")

func _process(delta):
	head_animation()

func switch_dialogue_box():
	$DialogueLabel/NinePatchRect.visible = true
	$DialogueLabel.anchor_left = 0.7
	$DialogueLabel.anchor_right = 0.95
	$DialogueLabel.anchor_top = 0.1
	$DialogueLabel.anchor_bottom = 0.3
	$DialogueLabel.remove_font_override("normal_font")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://locations/battle/battle.tscn")
