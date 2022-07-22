extends Spatial

onready var vis = find_node("VisibilityNotifier")

func _ready():
	return
	if vis != null:
		self.visible = false
		vis.connect("camera_entered", self, "visibility_callback", [true])
		vis.connect("camera_exited", self, "visibility_callback", [false])
	pass # Replace with function body.

func visibility_callback(camera, visibility):
	self.visible = visibility
