extends Node



func _ready():
	listen_for_boss_low_health_mode()


func boss_low_health_mode():
	print("ENTERING BOSS LOW HEALTH MODE")
	$"%enemy".disconnect("low_health_mode", self, "boss_low_health_mode")
	disable_talk_item_buttons()
	$"%gui".end_fight_sequence = 0

func disable_talk_item_buttons():
	var gui = $"%gui"
	gui.set_talk_disabled(true)
	gui.set_pack_disabled(true)



func listen_for_boss_low_health_mode():
	var boss = $"%enemy"
	boss.connect("low_health_mode", self, "boss_low_health_mode")
