extends Spatial

export(Array, String) var first_dialogue
export(Array, String) var first_dialogue_2
export(Array, String) var second_dialogue
export(Array, String) var third_dialogue
export(Array, String) var third_dialogue_2

const exclamation_sound = preload("res://sounds/exclamation.ogg")
const battlefall_sound = preload("res://sounds/battlefall.ogg")

var stage = 0
var stage2_dialogue_played = false



func _ready():
	pass

func _on_start_trigger_body_entered(body):
	if body.name == "player" and stage == 0:
		get_node("../moony").follow_player = false
		get_node("../moony/decoration").messages = ["POST_THRONE_MOONY_DIALOUGE1","POST_THRONE_MOONY_DIALOUGE2"]
		var moony = get_node("../moony")
		var player = get_node("../player")
		var moony_destination = Vector3(player.translation.x-5, moony.translation.y, player.translation.z + 3)
		$Tween.interpolate_property(moony, "translation", moony.translation, moony_destination, 2 )
		
		body.can_control = false
		
		$Tween.interpolate_property(get_node("../player"), "rotation_degrees", get_node("../player").rotation_degrees, Vector3(0,90,0), 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.interpolate_property(get_node("../player/Camera"), "rotation_degrees", get_node("../player/Camera").rotation_degrees, Vector3(0,0,0), 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
		
		get_node("../player/gui").dialogue_start(first_dialogue)
		get_node("../player/gui").connect("dialogue_end", self, "stage1_end")
		
		stage = 1

func _on_walk_trigger_body_entered(body):
	if body.name == "player" and stage == 1:
		get_node("../frog_ending").translation = Vector3(1,3,63)
		get_node("../moony").disable_dialogue()
		
		$Timer.start()
		
		$Tween.interpolate_property(get_node("../player"), "translation", get_node("../player").translation, Vector3(-43,1.752,-1.5), 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()

func stage1_end():
	get_node("../player").can_control = false
	get_node("../player/gui").disconnect("dialogue_end", self, "stage1_end")
	$AnimationPlayer.play("exclamation")
	Globals.play_sound(exclamation_sound)
	$AnimationPlayer.connect("animation_finished", self, "exclamation_ended")
	get_node("../player/gui").connect("dialogue_next", self, "mooney_talk")
	
	$Tween.interpolate_property(get_node("../player"), "translation", get_node("../player").translation, get_node("../player").translation + Vector3(-1,0,0), 0.5)

func stage11_end():
	#get_node("../player/gui").disconnect("dialogue_end", self, "stage1_end")
	$AnimationPlayer.play("meist_walking_away")
	get_node("../moony").follow_player = true
	get_node("../player").can_control = true
	
	get_node("../player/gui").disconnect("dialogue_end", self, "stage11_end")
	get_node("../player/gui").disconnect("dialogue_next", self, "mooney_talk")
	get_node("../moony").reset_animation()

func stage3_start():
	get_node("../moony").enable_dialogue()
	stage = 3
	$AnimationPlayer.play("meist_goes_to_garden")
	get_node("../player").can_control = true

func stage2_dialogue_ended():
	if $AnimationPlayer.is_playing():
		get_node("../player").can_control = false
	else:
		stage3_start()
	stage2_dialogue_played = true
	get_node("../player/gui").disconnect("dialogue_end", self, "stage2_dialogue_ended")

func stage2_animation_ended(test_val):
	$AnimationPlayer.disconnect("animation_finished", self, "stage2_animation_ended")
	if stage2_dialogue_played:
		stage3_start()

func _on_Timer_timeout():
	if stage == 1:
		$AnimationPlayer.play("walk_with_meist")
		$AnimationPlayer.connect("animation_finished", self, "stage2_animation_ended")
		get_node("../player/gui").dialogue_start(second_dialogue)
		get_node("../player/gui").connect("dialogue_end", self, "stage2_dialogue_ended")
		stage = 2

func _on_battle_trigger_body_entered(body):
	if body.name == "player":
		body.can_control = false
		
		$Tween.interpolate_property(get_node("../player"), "rotation_degrees", get_node("../player").rotation_degrees, Vector3(0,90,0), 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.interpolate_property(get_node("../player/Camera"), "rotation_degrees", get_node("../player/Camera").rotation_degrees, Vector3(0,0,0), 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
		
		get_node("../player/gui").dialogue_start(third_dialogue)
		get_node("../player/gui").connect("dialogue_end", self, "turn_meist")
		get_node("../player/gui").connect("dialogue_next", self, "stop_small_shock")
		
		stage = 4

func turn_meist():
	get_node("../player").can_control = false
	$AnimationPlayer.play("turn_around")
	$AnimationPlayer.connect("animation_finished", self, "final_dialogue")
	get_node("../player/gui").disconnect("dialogue_end", self, "turn_meist")

func stop_small_shock(dialogue):
	if dialogue == 10:
		get_node("../general_music").stop()

func battle_start():
	SaveData.save_data("disable_intro", true)
	Globals.play_sound(battlefall_sound)
	get_tree().change_scene("res://locations/battle_transition.tscn")

func exclamation_ended(anim_name:String):
	if anim_name == "exclamation":
		get_node("../player").can_control = false
		get_node("../player/gui").dialogue_start(first_dialogue_2)
		get_node("../player/gui").connect("dialogue_end", self, "stage11_end")
		get_node("../general_music").play()

func mooney_talk(dialogue):
	get_node("../moony").talking = true
	get_node("../moony/decoration").animation = "default"
	if dialogue == 2 or dialogue == 11 or dialogue == 15:
		get_node("../moony/decoration").animation = "talk_default"
	if dialogue == 12:
		get_node("../moony/decoration").animation = "talk_angry"

func final_dialogue(anim_name):
	get_node("../player/gui").dialogue_start(third_dialogue_2)
	get_node("../player/gui").connect("dialogue_end", self, "battle_start")
