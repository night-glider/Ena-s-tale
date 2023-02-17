extends Control

var active = false
var current_damage = 0
var orbs = []
var orb_scene = preload('res://locations/battle/attack_orb.tscn')

signal attack_ended()
signal damage_dealt(damage)

func choice(list):
	return list[randi() % list.size()]

func _ready():
	$center.visible = false

func start_attack(orbs_count = 5, dmg = 500):
	$label.rect_pivot_offset = $label.rect_size/2
	$AnimationPlayer.play("ready_go")
	$end_timer.start()
	visible = true
	current_damage = 0
	for i in orbs_count:
		var new_orb = orb_scene.instance()
		var new_orb_pos = Vector2(1,0).rotated(choice([0, PI])).rotated(rand_range(-0.5,0.5))
		new_orb_pos = $center.rect_position + (new_orb_pos * ($center.rect_position.x + i*50+100))
		
		new_orb.init(new_orb_pos, $center.rect_position, 2, dmg/orbs_count)
		add_child(new_orb)
		orbs.append( new_orb )

func end_attack():
	$end_timer.stop()
	emit_signal("damage_dealt", current_damage)
	emit_signal("attack_ended")
	active = false
	visible = false
	$center.visible = false

func _process(delta):
	if not active:
		return

	if Input.is_action_just_pressed("interact"):
		var orb = orbs.pop_front()
		
		if $center.rect_position.distance_to(orb.position) < 20:
			current_damage+= orb.damage
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
