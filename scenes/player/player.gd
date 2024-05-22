extends CharacterBody3D
class_name Player

# TODO:
# add particles and sound to play when breaking crates
@onready var player_model = %lowpoly_cat
@onready var animation_player = $lowpoly_cat/AnimationPlayer
@onready var state_chart = %StateChart
@onready var player_hurtbox = %PlayerHurtbox
@onready var foot_steps = %FootSteps

signal death
signal dying
signal swap_camera

const SPEED = 3.5
const JUMP_VELOCITY = 4.5
const BOUNCE_IMPULSE = 5.0

const GROUND_ACCEL = 20.0
const AIR_ACCEL = 8
var accel = GROUND_ACCEL

var alive: bool = true
var spinning: bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction = Vector3.ZERO


func _process(_delta):
	if direction and alive and not spinning:
		var angle_target := atan2(-direction.x, -direction.z)
		player_model.rotation.y = lerp_angle(player_model.rotation.y, angle_target, 0.1)
	
	if Input.is_action_just_pressed("attack"):
		state_chart.send_event("attack")
	
## general physics regardless of state
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		accel = AIR_ACCEL
	else:
		accel = GROUND_ACCEL
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("right", "left", "backward", "forward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and alive:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, accel * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	Globals.player_pos = global_position
	
	if not alive:
		return
	
	# STOMPING LOGIC
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		
		if !(collider.is_in_group("CanBounce")):
			continue
		
		# hitting crates from below, dont bounce player
		if collider.is_in_group("Breakable") and collision.get_normal() == Vector3.DOWN:
			collider.stomp()
			$Sounds/BounceSound.play()
			continue
		
		# dot product is the length of the projection of the normal over the "Up" vector
		# if it's 1 it's straight up, if it's 0 it's perpendicular
		var is_stomping = (
			(collider.is_in_group("Breakable") or collider.is_in_group("Enemy"))
			and is_on_floor()
			and collision.get_normal().dot(Vector3.UP) > 0.5
		)
		
		if is_stomping:
			$Sounds/BounceSound.play()
			jump(BOUNCE_IMPULSE)
			collider.stomp()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Spin":
		spinning = false
		state_chart.send_event("attack_finish")
		return
	if anim_name == "Death":
		death.emit()

func hit():
	#some hit sound
	state_chart.send_event("death")

func fall():
	%Sounds/FallSound.play()
	state_chart.send_event("death")

func jump(vel = JUMP_VELOCITY):
	velocity.y = vel
	state_chart.send_event("jumped")

# play random footstep sound, used by animation player
func step():
	foot_steps.get_children().pick_random().play()

## GROUNDED LOGIC
func _on_grounded_state_entered():
	$Sounds/FootSteps/AudioStreamPlayer3D2.play()

func _on_grounded_state_physics_processing(_delta):
	if is_on_floor():
		if direction:
			animation_player.play("Run", -1, 1.2)
		else:
			animation_player.play("Idle", 0.2)
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			jump()
		return
	
	state_chart.send_event("left_ground")


## ON AIR JUMP ENABLED LOGIC (for coyote time)
func _on_on_air_can_jump_state_entered():
	animation_player.play("Falling", 0.3)

func _on_on_air_can_jump_state_physics_processing(_delta):
	if Input.is_action_just_pressed("jump"):
		jump()


## JUMPED LOGIC
func _on_jumped_state_entered():
	animation_player.play("Jump")

func _on_jumped_state_physics_processing(_delta):
	if velocity.y < 0:
		state_chart.send_event("falling")

## FALLING LOGIC
func _on_on_air_cannot_jump_state_entered():
	animation_player.play("Falling", 0.3)

func _on_on_air_cannot_jump_state_physics_processing(_delta):
	if is_on_floor():
		state_chart.send_event("grounded")

## ATTACK LOGIC
func _on_spinning_state_entered():
	spinning = true
	player_hurtbox.set_deferred("monitorable", true)
	animation_player.play("Spin", -1, 1.5)

func _on_spinning_state_exited():
	player_hurtbox.set_deferred("monitorable", false)


func _on_dead_state_entered():
	alive = false
	dying.emit()
	animation_player.play("Death", -1, 1.5)


