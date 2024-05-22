extends Node3D
class_name Level

@onready var player = %Player
@onready var animation_player = %AnimationPlayer
@onready var teleporter_exit = %TeleporterExit

@export var next_level: Level

func _ready():
	Globals.cans = 0
	Globals.broken_crates = 0
	animation_player.play("FadeIn")
	player.death.connect(_on_player_death)
	player.dying.connect(_on_player_dying)
	teleporter_exit.level_won.connect(_on_level_won)
	Globals.max_crates_in_level = get_tree().get_nodes_in_group("Breakable").size()

func _on_player_dying():
	animation_player.play("FadeOut")

func _on_player_death():
	# fade to black
	Globals.extra_lives -= 1
	get_tree().reload_current_scene()

func _on_level_won():
	animation_player.play("FadeOut")
	await get_tree().create_timer(2.0).timeout
	if next_level:
		get_tree().change_scene_to_file(next_level.get_path())
	else:
		get_tree().quit()
