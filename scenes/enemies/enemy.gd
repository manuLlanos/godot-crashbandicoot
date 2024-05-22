extends CharacterBody3D
class_name Enemy

## TODO: make them fly away in the direction of the hit
## with no collision, just for about 2 seconds then delete them
func hit(_pos):
	queue_free()

# define in child
func stomp():
	pass
