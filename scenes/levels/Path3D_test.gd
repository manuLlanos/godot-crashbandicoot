extends Path3D
@onready var path_follow_3d = $PathFollow3D

func _process(delta):
	path_follow_3d.progress_ratio += delta
