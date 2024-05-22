extends Area3D

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	if !parent:
		push_error("HITBOX SHOULD BE CHILD OF A NODE")
	if !("hit" in parent):
		push_error("HITBOX PARENT SHOULD HAVE A HIT METHOD")
	if !$CollisionShape3D.shape:
		push_error("HITBOX COLLISION SHAPE EMPTY")


# should only detect hurtboxes set in the mask layer using the editr
func _on_area_entered(area):
	if parent is Enemy:
		parent.hit(area.global_position)
	else:
		parent.hit()
