extends StaticBody3D

@onready var animation_player = %AnimationPlayer
@onready var explosion = %Explosion
@onready var tnt_crate = %TNT_crate
@onready var cube_mesh: MeshInstance3D = $TNT_crate/Cube
@onready var hitbox = %Hitbox
@onready var hurtbox = %Hurtbox

@onready var collision_shape = %CollisionShape3D

var explosion_scene: PackedScene = preload("res://scenes/world/explosion.tscn")

var activated: bool = false

func _ready():
	explosion.finished.connect(func(): queue_free())

func hit():
	animation_player.stop()
	create_explosion()
	$Timer.start()
	tnt_crate.hide()
	hurtbox.set_deferred("monitorable", true)
	hitbox.set_deferred("monitoring", false)
	collision_shape.set_deferred("disabled", true)
	explosion.play()
	Globals.broken_crates += 1

func stomp():
	if activated:
		return
	activated = true
	remove_from_group("CanBounce")
	animation_player.play("Activated")

func create_explosion():
	var explosion_obj = explosion_scene.instantiate()
	explosion_obj.position = $TNT_crate/Cube.global_position
	get_parent().add_child(explosion_obj)


func _on_timer_timeout():
	hurtbox.set_deferred("monitorable", false)
