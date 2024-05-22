extends Node3D

##Time between activations
@export var attack_wait_time: float = 2.0
##Time before the first activation timer starts
@export var start_delay: float = 0.0

@onready var attack_timer = %AttackTimer
@onready var delay_timer = %DelayTimer

@onready var animation_player = $speartrap/AnimationPlayer


func _ready():
	if start_delay:
		delay_timer.wait_time = start_delay
		delay_timer.timeout.connect(start_timer)
		delay_timer.start()
	else:
		start_timer()

func start_timer():
	attack_timer.wait_time = attack_wait_time
	attack_timer.start()

func _on_attack_timer_timeout():
	animation_player.play("Attack")


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "Attack"):
		animation_player.play("Idle ")
		attack_timer.start()
