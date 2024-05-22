extends Area3D

signal level_won

func _on_body_entered(_body):
	level_won.emit()
