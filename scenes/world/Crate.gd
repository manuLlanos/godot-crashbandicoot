extends StaticBody3D
class_name Crate

@onready var cube = $Cube
@onready var hitbox = $Hitbox
@onready var collision_shape_3d = $CollisionShape3D
@onready var audio_stream_player_3d = %AudioStreamPlayer3D
@onready var particle_spawn_point = %ParticleSpawnPoint

var particles_scene: PackedScene = preload("res://scenes/world/crate_explosion_particles.tscn")
var food_can_scene: PackedScene = preload("res://scenes/pickups/food-can.tscn")

# to prevent a bug where some crates get counted more than once
var broken: bool = false

func _ready():
	audio_stream_player_3d.finished.connect(func(): queue_free())

# when hit by player spin attack
func hit():
	broken = true
	spawn_can()
	cube.hide()
	hitbox.set_deferred("monitoring", false)
	collision_shape_3d.set_deferred("disabled", true)
	
	spawn_particles()
	audio_stream_player_3d.play()
	
	Globals.broken_crates += 1

# when the players lands on it
func stomp():
	if broken:
		return
	hit()


func spawn_can(pos: Vector3 = Vector3.ZERO):
	var food_can = food_can_scene.instantiate()
	food_can.transform = transform
	if pos:
		food_can.position = pos
	get_parent().add_child(food_can)


func spawn_particles():
	var particles = particles_scene.instantiate()
	particles.position = particle_spawn_point.global_position
	get_parent().add_child(particles)
