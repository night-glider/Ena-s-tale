extends Node
class_name global

var player_name:String
var error_message:String
var game_over_soul_position:Vector2 = Vector2.ZERO

func _ready():
	var volume = SaveData.load_data("master", 10)
	change_bus_volume("Master", volume)

	volume = SaveData.load_data("music", 10)
	change_bus_volume("music", volume)

	volume = SaveData.load_data("sound", 10)
	change_bus_volume("sound", volume)


func change_bus_volume(bus_name:String, volume:float):
	if volume == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear2db(volume))

func crash(msg:String):
	error_message = msg
	get_tree().change_scene("res://locations/crash_screen.tscn")


func game_over(soul_position:Vector2 = Vector2(-100,-100)):
	game_over_soul_position = soul_position
	get_tree().change_scene("res://locations/game_over.tscn")

func play_sound(sound:AudioStream):
	var audio_player := AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.bus = "sound"
	audio_player.stream = sound
	audio_player.play()
