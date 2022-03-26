extends Spatial

export(Array, String) var first_dialogue
export(Array, String) var second_dialogue
export(Array, String) var third_dialogue

var stage = 0
var stage2_dialogue_played = false

func _ready():
	for i in first_dialogue.size():
		first_dialogue[i] = tr(first_dialogue[i])

func _on_start_trigger_body_entered(body):
	if body.name == "player" and stage == 0:
		body.can_control = false
		
		$Tween.interpolate_property(get_node("../player"), "rotation_degrees", get_node("../player").rotation_degrees, Vector3(0,90,0), 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.interpolate_property(get_node("../player/Camera"), "rotation_degrees", get_node("../player/Camera").rotation_degrees, Vector3(0,0,0), 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
		
		get_node("../player/GUI").dialogue_start(first_dialogue)
		get_node("../player/GUI").connect("dialogue_end", self, "stage1_end")
		stage = 1

func _on_walk_trigger_body_entered(body):
	if body.name == "player" and stage == 1:
		$Timer.start()
		
		$Tween.interpolate_property(get_node("../player"), "translation", get_node("../player").translation, Vector3(-43,1.752,-1.5), 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()

func stage1_end():
	get_node("../player/GUI").disconnect("dialogue_end", self, "stage1_end")
	$AnimationPlayer.play("meist_walking_away")

func stage3_start():
	stage = 3
	$AnimationPlayer.play("meist_goes_to_garden")
	get_node("../player").can_control = true

func stage2_dialogue_ended():
	if $AnimationPlayer.is_playing():
		get_node("../player").can_control = false
	else:
		stage3_start()
	stage2_dialogue_played = true
	get_node("../player/GUI").disconnect("dialogue_end", self, "stage2_dialogue_ended")

func stage2_animation_ended(test_val):
	$AnimationPlayer.disconnect("animation_finished", self, "stage2_animation_ended")
	if stage2_dialogue_played:
		stage3_start()

func _on_Timer_timeout():
	if stage == 1:
		$AnimationPlayer.play("walk_with_meist")
		$AnimationPlayer.connect("animation_finished", self, "stage2_animation_ended")
		get_node("../player/GUI").dialogue_start(second_dialogue)
		get_node("../player/GUI").connect("dialogue_end", self, "stage2_dialogue_ended")
		stage = 2


func _on_battle_trigger_body_entered(body):
	if body.name == "player":
		body.can_control = false
		
		$Tween.interpolate_property(get_node("../player"), "rotation_degrees", get_node("../player").rotation_degrees, Vector3(0,90,0), 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.interpolate_property(get_node("../player/Camera"), "rotation_degrees", get_node("../player/Camera").rotation_degrees, Vector3(0,0,0), 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
		
		get_node("../player/GUI").dialogue_start(third_dialogue)
		get_node("../player/GUI").connect("dialogue_end", self, "battle_start")
		stage = 4

func battle_start():
	get_tree().change_scene("res://locations/battle/battle.tscn")
