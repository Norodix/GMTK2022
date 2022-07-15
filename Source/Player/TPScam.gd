extends Position3D

export var mouse_sensitivity = 1.2
export var mouse_sensitivity_multiplier = 1.0 / 1000.0
export var cam_tilt_default = 0.5
export var joystick_sensitivity = 5
var cam_sensitivity

onready var parentObject = get_parent()

# Cursor
onready var is_cursor_visible setget set_is_cursor_visible, get_is_cursor_visible
func set_is_cursor_visible(value): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if value else Input.MOUSE_MODE_CAPTURED)
func get_is_cursor_visible(): return Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE

# TODO move camera independent of player when standing still

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_as_toplevel(true)
	set_is_cursor_visible(false)
	$Path/PathFollow.unit_offset = cam_tilt_default
	cam_sensitivity = mouse_sensitivity * mouse_sensitivity_multiplier
	pass # Replace with function body.


func _process(delta):
	process_joystick_camera(delta)


func process_joystick_camera(delta) -> void:
	self.global_transform.origin = parentObject.global_transform.origin
	# TODO add acceleration to joystick camera
	var deadZone = 0.1
	var inputDir = Input.get_vector("CamJoystickLeft", "CamJoystickRight", "CamJoystickUp", "CamJoystickDown", deadZone)
	if abs(inputDir.x) > deadZone:
		rotateY( - inputDir.x * joystick_sensitivity * delta)
	if abs(inputDir.y) > deadZone:
		rotateX(inputDir.y * joystick_sensitivity * delta)
	

func _unhandled_input(event: InputEvent) -> void:
	process_mouse_input(event)


func process_mouse_input(event):
	# Cursor movement
	if event is InputEventMouseMotion:
		rotateX(event.relative.y * cam_sensitivity)
		rotateY( - event.relative.x * cam_sensitivity)


# Vertical rotation
func rotateY(rad):
	self.rotate_y(rad)

# Horizontal rotation
func rotateX(rad):
	# One unit roughly equals PI rotation
	var new_offset = $Path/PathFollow.unit_offset + rad / PI
	$Path/PathFollow.unit_offset = clamp(new_offset, 0.0, 0.95);
	pass
