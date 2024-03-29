class_name BigBoss extends AnimatedSprite

const damage_sound = preload("res://sounds/damage.ogg")
const avoid_attack = preload("res://objects/battle/attacks/attack0/attack0.tscn")

var player_data:Node2D = null

var all_attacks = [2,3,4,5,6,7,8]
var current_attack_pool = []

var animate_head = true
var _hp = 20000
export(int) var health_floor = 5000

var head_n = 0
var head_n_spd = PI/120.0

signal low_health_mode

func toggle_default_animation():
	$AnimationPlayer.play("RESET")
	animate_head = true
	#$AnimationPlayer.play("default")

func toggle_fire_storm():
	animate_head = false
	$AnimationPlayer.play("fire_storm")

func start_shadow_anim():
	$AnimationPlayer.play("shadow_attack_start")

func start_swing_anim():
	$AnimationPlayer.play("swing")

func sword_down_static():
	$AnimationPlayer.play("sword_down_and_static")

func sword_down_charge():
	$AnimationPlayer.play("sword_down_and_charge")

func sword_up():
	$AnimationPlayer.play("sword_up")

func head_animation():
	if not animate_head:
		return
	$head.position.y = 4 + sin(head_n) * 2
	head_n += head_n_spd

func _ready():
	for i in all_attacks.size():
		all_attacks[i] = load("res://objects/battle/attacks/attack{0}/attack{0}.tscn".format([all_attacks[i]]))
	
	current_attack_pool = all_attacks.duplicate()

func _process(delta):
	head_animation()

func choose_attack()->PackedScene:
	if player_data.hp <= 15:
		return avoid_attack
	
	if current_attack_pool.empty():
		current_attack_pool = all_attacks.duplicate()
		current_attack_pool.shuffle()
	
	return current_attack_pool.pop_front()

func last_action_decision(action:String)->Array:
	if _hp >= 20000:
		return ["pass"]
	
	var answer = ["none"]
	answer = ["attack"]
	return answer
	
	#unused stuff
	match action:
		"turron": 
			answer[0] = "pass" 
			#answer.append(["ENEMY_TURRON_REACT"])
			return answer
		"qwerty":
			answer[0] = "pass" 
			#answer.append(["ENEMY_QWERTY_REACT"])
			return answer
		"joltest":
			answer[0] = "pass" 
			#answer.append(["ENEMY_JOLTEST_REACT"])
			return answer
		"check":
			answer[0] = "pass" 
			#answer.append(["ENEMY_CHECK_REACT"])
			return answer
		"insult":
			answer[0] = "pass" 
			#answer.append(["ENEMY_INSULT_REACT"])
			return answer
		"reason":
			answer[0] = "pass" 
			answer.append(["ENEMY_REASON_REACT"])
			return answer
		"reason_failed":
			answer[0] = "pass" 
			#answer.append(["ENEMY_REASON_REACT"])
			return answer
		"attack":
			answer[0] = "pass" 
			#answer.append(["ENEMY_INSULT_REACT"])
			return answer

func set_hp(value : int):
	_hp = value
	if _hp < health_floor:
		_hp = health_floor
		emit_signal("low_health_mode")

## TESTING ONLY
func _input(event):
	if event.is_action_pressed("kill_boss_cheat"):
		take_hit(14999)

func take_hit(damage : int):
	set_hp(_hp - damage)
	
	if damage <= 0:
		$hp_bar/Label.modulate = Color.white
		$hp_bar/Label.text = "MISS"
	else:
		$hp_bar/Label.modulate = Color.red
		$hp_bar/Label.text = str(damage)
	$hp_bar/anim.play("simple_anim")
	$hp_bar/smooth.interpolate_property($hp_bar, "value", $hp_bar.value, _hp, 1)
	$hp_bar/smooth.start()
	if damage > 0:
		Globals.play_sound(damage_sound)


func _on_attack_dot_pressed(big):
	$small_explosion.frame = 0
	if big:
		$small_explosion.scale = Vector2(3,3)
		$small_explosion.position = Vector2.ZERO
		return
	
	$small_explosion.scale = Vector2(1,1)
	$small_explosion.position = Vector2(rand_range(-50,40), rand_range(-50,50))
