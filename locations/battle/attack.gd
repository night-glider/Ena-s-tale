extends Control

var active = false
var orb_count = 0
var max_damage = 0
var current_damage = 0

onready var orbs = $orbs.get_children()

signal attack_ended(damage)

func _ready():
	pass
	#start_attack()

func start_attack(orbs_count = 5, dmg = 2000):
	visible = true
	max_damage = dmg
	orb_count = orbs_count
	current_damage = 0
	
	for i in orb_count:
		orbs[i].position.x = rand_range(0, rect_size.x)
		orbs[i].position.y = rand_range(0, rect_size.y)
		orbs[i].init($center.rect_position)
		orbs[i].visible = true

func _process(delta):
	
	for elem in orbs:
		if elem.visible:
			if $center.rect_position.distance_to(elem.position) < 1:
				elem.visible = false
				check_if_ended()
	
	if Input.is_action_just_pressed("interact"):
		for elem in orbs:
			if elem.visible:
				if $center.rect_position.distance_to(elem.position) < 20:
					elem.visible = false
					current_damage+=max_damage/orb_count
					check_if_ended()
		
		$center/press_effect/anim.stop()
		$center/press_effect/anim.play("press")

func check_if_ended():
	for elem in orbs:
		if elem.visible:
			return true
	emit_signal("attack_ended", current_damage)


func _on_attack_attack_ended(damage):
	visible = false
	
