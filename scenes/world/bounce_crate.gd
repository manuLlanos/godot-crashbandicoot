extends Crate
class_name BounceCrate

@onready var animation_player = $Cube/AnimationPlayer


const MAX_STOMP: int = 5
var stomp_count: int = 0

func stomp():
	spawn_can(Globals.player_pos)
	animation_player.play("Bounce_001")
	stomp_count += 1
	if stomp_count >= MAX_STOMP:
		hit()
