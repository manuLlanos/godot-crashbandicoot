extends Area3D


# should only detect player
func _on_body_entered(_body):
	set_deferred("monitoring", false)
	hide()
	Globals.cans += 1
	$PickupSound.play()



func _on_pickup_sound_finished():
	queue_free()
