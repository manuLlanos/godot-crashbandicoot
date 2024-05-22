extends CanvasLayer

@onready var lives_label = %LivesLabel
@onready var cans_label = %CansLabel
@onready var crates_label = %CratesLabel

func _ready():
	Globals.update_ui.connect(update_ui)
	update_ui()

func update_ui():
	lives_label.text = str(Globals.extra_lives)
	cans_label.text = str(Globals.cans)
	crates_label.text = str(Globals.broken_crates) + "/" + str(Globals.max_crates_in_level)
