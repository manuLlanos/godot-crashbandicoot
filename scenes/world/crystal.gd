extends Area3D

@onready var crystal = %crystal


func _ready():
	crystal.hide()
	
	Globals.spawn_crystal.connect(_on_spawn_crystal)

func _on_spawn_crystal():
	set_deferred("monitoring", true)
	crystal.show()


func _on_body_entered(_body):
	Globals.crystals += 1
	queue_free()
