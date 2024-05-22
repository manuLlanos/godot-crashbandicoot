extends Node

var player_pos: Vector3 = Vector3.ZERO

signal update_ui
signal spawn_crystal

var cans: int = 0:
	set(value):
		if value >= 100:
			extra_lives += 1
			cans = 0
			return
		cans = value
		update_ui.emit()

var extra_lives: int = 2:
	set(value):
		if value < 0:
			# game over
			return
		extra_lives = value
		update_ui.emit()

var max_crates_in_level: int = 0:
	set(value):
		max_crates_in_level = value
		update_ui.emit()

var broken_crates: int = 0:
	set(value):
		broken_crates = value
		if broken_crates == max_crates_in_level and max_crates_in_level != 0:
			spawn_crystal.emit()
		update_ui.emit()

var crystals: int = 0
