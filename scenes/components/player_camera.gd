#Camera that follows the player only along the z-axis
#by copying their velocity
extends Camera3D
class_name PlayerCamera

@export var player: Player
@export var initial_state = States.FORWARD_FOLLOW

var distance_vector: Vector3

enum States{FORWARD_FOLLOW, SIDE_FOLLOW, VERTICAL_FOLLOW, STATIC}
var _state

func _ready():
	if !player:
		push_error("Player not asigned to camera")
	
	distance_vector = global_position - player.global_position
	
	_state = initial_state
	player.swap_camera.connect(swap_mode)

func _process(_delta):
	match _state:
		States.FORWARD_FOLLOW:
			position.z = distance_vector.z + player.global_position.z
		States.SIDE_FOLLOW:
			position.x = distance_vector.x + player.global_position.x
		States.VERTICAL_FOLLOW:
			position.y = distance_vector.y + player.global_position.y

func swap_mode(state):
	_state = state
