extends Crate

var life_scene: PackedScene = preload("res://scenes/pickups/life.tscn")


# spawn multiple cans or a life
func hit():
	Globals.broken_crates += 1
	audio_stream_player_3d.play()
	cube.hide()
	hitbox.set_deferred("monitoring", false)
	collision_shape_3d.set_deferred("disabled", true)
	
	# random chance of spawning a life instead
	if randf() < 0.20:
		spawn_life()
	else:
		spawn_cans()

func spawn_life():
	var life = life_scene.instantiate()
	life.position = global_position
	get_parent().add_child(life)

func spawn_cans():
	for i in range(5):
			var rand_vector = Vector3(randf_range(-0.5, 0.5), 0, randf_range(-0.5, 0.5))
			spawn_can(global_position + rand_vector)
