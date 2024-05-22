extends Area3D

@onready var audio_stream_player = %AudioStreamPlayer


func _ready():
	audio_stream_player.finished.connect(func(): queue_free())

#should only detect player
func _on_body_entered(_body):
	$Sprite3D.hide()
	set_deferred("monitoring", false)
	Globals.extra_lives += 1
	audio_stream_player.play()
