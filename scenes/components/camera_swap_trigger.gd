extends Area3D


@export var state: PlayerCamera.States = PlayerCamera.States.FORWARD_FOLLOW

func _on_body_entered(body: Player):
	body.swap_camera.emit(state)
