extends Enemy

@onready var animation_player = $turtle/AnimationPlayer
@onready var state_chart = %StateChart
@onready var stomped_timer = %StompedTimer
@onready var hurtbox = %Hurtbox
@onready var fly_hurtbox = %FlyHurtbox
@onready var hitbox = %Hitbox
@onready var turtle = %turtle
@onready var desired_model_rotation: float = 0


var speed = 1.2
var fly_speed = 30

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## Max distance travelled before turtle turns around
@export var max_distance: float = 3
var distance_travelled: float = 0
var flipped: bool = false

var hit_pos: Vector3 = Vector3.ZERO
var fly_dir: Vector3 = Vector3.RIGHT

func hit(pos):
	hit_pos = pos
	state_chart.send_event("death")

func stomp():
	if flipped:
		animation_player.play("Bounce")
	stomped_timer.start()
	state_chart.send_event("stomped")

func _on_stomped_timer_timeout():
	state_chart.send_event("left_alone")

func _on_walking_state_entered():
	hurtbox.set_deferred("monitorable", true)
	animation_player.play("Walk", 0.9)


func _on_walking_state_physics_processing(delta):
	velocity = transform.basis.z * speed
	if not is_on_floor():
		velocity.y -= gravity
	distance_travelled += abs(speed) * delta
	if distance_travelled >= max_distance:
		distance_travelled = 0
		speed *= -1
		desired_model_rotation += PI
		if is_equal_approx(desired_model_rotation, 2*PI):
			desired_model_rotation = 0
	
	turtle.rotation.y = lerp_angle(turtle.rotation.y, desired_model_rotation, 5*delta)
	##smooth rotation
	## transform that is already looking at the target
	#var new_transform = turtle.transform.looking_at(turtle.transform.origin - speed * transform.basis.z)
	## interpolate current transform with desired transform
	#turtle.transform = turtle.transform.interpolate_with(new_transform, 5* delta)
	
	move_and_slide()


func _on_stomped_state_entered():
	animation_player.play("Stomped")
	flipped = true
	hurtbox.set_deferred("monitorable", false)

func _on_on_left_alone_taken():
	flipped = false
	animation_player.play("Stand")


func _on_dead_state_entered():
	$CollisionShape3D.queue_free()
	fly_hurtbox.set_deferred("monitorable", true)
	animation_player.pause()
	fly_dir = (global_position - Vector3(hit_pos.x, 0, hit_pos.z)).normalized()
	hitbox.queue_free()
	hurtbox.queue_free()
	$Sounds/Ricochet.play()
	$DeleteTimer.start()


func _on_dead_state_physics_processing(delta):
	position += fly_dir * fly_speed * delta


func _on_delete_timer_timeout():
	queue_free()
