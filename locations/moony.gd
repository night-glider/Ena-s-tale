extends Spatial

var talking = false
var follow_player = true
onready var player = get_node("../player")



func _ready():
	$AnimationPlayer.play("bob")
	$decoration/StaticBody.set_collision_layer_bit(0,false)
	$decoration/StaticBody.set_collision_mask_bit(0,false)
	
	$decoration/StaticBody.set_collision_layer_bit(1,true)
	$decoration/StaticBody.set_collision_mask_bit(1,true)
	
	get_node("../player/gui").connect("dialogue_end", self, "reset_animation")

func _process(delta):
	
	if talking:
		if get_node("../player/gui/dialogue/DialogueLabel").finished:
			$decoration.playing = false
			$decoration.frame = 1
		else:
			$decoration.playing = true
	
	if follow_player:
		if transform.origin.distance_to( player.transform.origin ) > 5:
			var pos = Vector2(transform.origin.x, transform.origin.z)
			var player_pos = Vector2(player.transform.origin.x, player.transform.origin.z)
			pos = lerp(pos, player_pos, 0.01)
			transform.origin.x = pos.x
			transform.origin.z = pos.y

func start_talking():
	talking = true
	$decoration.animation = "talk_default"

func reset_animation():
	talking = false
	$decoration.animation = "default"

func disable_dialogue():
	$decoration/StaticBody.set_collision_layer_bit(1,false)
	$decoration/StaticBody.set_collision_mask_bit(1,false)

func enable_dialogue():
	$decoration/StaticBody.set_collision_layer_bit(1,true)
	$decoration/StaticBody.set_collision_mask_bit(1,true)
