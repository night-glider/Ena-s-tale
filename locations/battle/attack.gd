extends Control

signal attack_ended()
signal damage_dealt(damage)
signal dot_pressed(big)

const orb_scene = preload('res://locations/battle/attack_orb.tscn')
const gigapunch = preload("res://sounds/gigapunch.ogg")
const punchstrong = preload("res://sounds/punchstrong.ogg")
const punchweak = preload("res://sounds/punchweak.ogg")

var active = false
var current_damage = 0
var max_damage = 0
var orbs = []
var accept_radius := 20


func choice(list):
	return list[randi() % list.size()]

func _ready():
	$center.visible = false

func start_attack(orbs_count = 5, dmg = 500, difficulty=0):
	match difficulty:
		0:
			$center/background.play("big")
			accept_radius = 20
		1:
			$center/background.play("middle")
			accept_radius = 17
		2:
			$center/background.play("small")
			accept_radius = 15
	max_damage = dmg
	$label.rect_pivot_offset = $label.rect_size/2
	$AnimationPlayer.play("ready_go")
	$end_timer.start()
	visible = true
	current_damage = 0
	var prev_orb_direction = Vector2(1,0).rotated(choice([0, PI])).rotated(rand_range(-0.5,0.5))
	for i in orbs_count:
		var new_orb = orb_scene.instance()
		prev_orb_direction = prev_orb_direction.rotated(rand_range(-0.5,0.5))
		var new_orb_pos = prev_orb_direction
		new_orb_pos = $center.rect_position + (new_orb_pos * ($center.rect_position.x + i*55+200))
		
		new_orb.init(new_orb_pos, Vector2(224,59), 4, max_damage/orbs_count)
		add_child(new_orb)
		orbs.append( new_orb )

func end_attack():
	$end_timer.stop()
	emit_signal("damage_dealt", current_damage)
	emit_signal("attack_ended")
	active = false
	visible = false
	$center.visible = false
	
	if current_damage == max_damage:
		Globals.play_sound(gigapunch)
	elif current_damage > 0:
		Globals.play_sound(punchstrong)

func _process(delta):
	if not active:
		return
	
	if Debug.ideal_attacks:
		for orb in orbs:
			if $center.rect_position.distance_to(orb.position) < accept_radius:
				Input.action_press("interact")
	
	if Input.is_action_just_pressed("interact"):
		var orb = orbs.pop_front()
		
		if $center.rect_position.distance_to(orb.position) < accept_radius:
			current_damage+= orb.damage
			Globals.play_sound(punchweak)
			var big_explosion = current_damage == max_damage
			emit_signal("dot_pressed", big_explosion)
		orb.queue_free()

		$center/press_effect/anim.stop()
		$center/press_effect/anim.play("press")
		
		if orbs.empty():
			end_attack()


func _on_end_timer_timeout():
	for i in orbs.size():
		var orb = orbs.pop_back()
		orb.queue_free()
	end_attack()


func _on_AnimationPlayer_animation_finished(anim_name):
	active = true
	$center.visible = true
