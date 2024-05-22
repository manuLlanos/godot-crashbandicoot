extends Node3D

@onready var sparks = %Sparks
@onready var fire = %Fire
@onready var flash = %Flash

func _ready():
	fire.finished.connect(func(): queue_free())
	
	sparks.emitting = true
	fire.emitting = true
	flash.emitting = true
