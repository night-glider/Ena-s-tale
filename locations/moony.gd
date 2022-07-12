extends Spatial

var follow_player = true
onready var player = get_node("../player")

func _ready():
	$AnimationPlayer.play("bob")

func _process(delta):
	if follow_player:
		if transform.origin.distance_to( player.transform.origin ) > 5:
			var pos = Vector2(transform.origin.x, transform.origin.z)
			var player_pos = Vector2(player.transform.origin.x, player.transform.origin.z)
			pos = lerp(pos, player_pos, 0.01)
			transform.origin.x = pos.x
			transform.origin.z = pos.y
