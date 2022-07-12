extends KinematicBody

export var acceleration = 40
var gravity = Vector3(0.0, - 9.8, 0.0) * 3

var velocity : Vector3 = Vector3.ZERO

export var max_speed = 5

export var jump_height = 1.2

export var maxJumps = 2
var jumpsLeft

export(NodePath) var cameraObjectPath
onready var cameraObject = get_node(cameraObjectPath)


func _ready():
	jumpsLeft = maxJumps
	pass


func _physics_process(delta):
	# Get target direction
	var inputDir = Input.get_vector("Left", "Right", "Up", "Down")
	
	var targetVelocity : Vector3 = self.global_transform.basis * Vector3(inputDir.x, 0.0, inputDir.y) * max_speed
	var horizontalVelocity = velocity * Vector3(1.0, 0.0, 1.0)
	var deltaV = targetVelocity - horizontalVelocity
	if deltaV.length() > acceleration * delta:
		deltaV = deltaV.normalized() * acceleration * delta
	velocity += deltaV
	
	velocity += gravity * delta
	
	handle_jump()
	
	if horizontalVelocity.length() > 0.01 * max_speed:
		if is_instance_valid(cameraObject):
			self.global_transform.basis = self.global_transform.interpolate_with(cameraObject.global_transform, 0.3).basis
	
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if self.global_transform.origin.y < -100:
		resetPosition()
	pass


func jump() -> void:
	# 1/2 * m * v^2 = m*g*h -> sqrt(2*g*h) = v
	var v = sqrt(abs(2 * gravity.length() * jump_height))
	velocity.y = v
	if $CoyoteTimer.is_stopped():
		jumpsLeft -= 1


func is_jump_triggered() -> bool:
	return not $JumpBuffer.is_stopped()


func can_jump() -> bool:
	var t = is_jump_triggered()
	var j = jumpsLeft > 0
	return t and j


func handle_jump():
	if Input.is_action_just_pressed("Jump"):
		$JumpBuffer.start()
	
	if is_on_floor():
		$CoyoteTimer.start()
		jumpsLeft = maxJumps
	
	if can_jump():
		jump()
		$CoyoteTimer.stop()
		$JumpBuffer.stop()


func resetPosition():
	self.global_transform.origin = Vector3(0.0, 1.0, 0.0)
