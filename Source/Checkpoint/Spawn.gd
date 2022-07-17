extends Position3D


func _ready():
	# Set start as checkpoint if undefined
	if CheckPointSingleton.checkpoint == null:
		CheckPointSingleton.checkpoint = self.global_transform
	pass # Replace with function body.
