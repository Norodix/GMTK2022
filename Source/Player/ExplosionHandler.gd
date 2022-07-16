extends Spatial

export var impulseCenter = 10
export var falloffFactor = 2
export var verticlBias = 2
export var biasFalloff = 3

var jumpImpulse = 4

var maxDistance

# Called when the node enters the scene tree for the first time.
func _ready():
	maxDistance = $Area/CollisionShape.shape.radius
	print("Max distance of explosion: ", maxDistance)
	$AnimationPlayer.set_blend_time("ExplosionSquish", "stop", 1)
	pass # Replace with function body.


func _process(delta):
	$Particles.global_transform.basis = Basis.IDENTITY


func explode():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("ExplosionSquish")
	yield(get_tree().create_timer(0.1), "timeout")
	
	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		if body is RigidBody:
			if body.mode == RigidBody.MODE_RIGID:
				# body can be pushed
				if body == get_parent():
					continue
				var distance : Vector3 = body.global_transform.origin - global_transform.origin
				var d : float = (distance/maxDistance).length()
				# Vertical bias should also have a falloff
				var bias = falloff(d, biasFalloff) * verticlBias
				# Add bias to direction
				var dir : Vector3 = (distance.normalized() + Vector3(0, bias, 0)).normalized()
				var impulse : Vector3 = falloff(d, falloffFactor) * impulseCenter * dir
				body.apply_central_impulse(impulse)
				var torque = Vector3(randf(), randf(), randf()).normalized() / 5
				body.apply_torque_impulse(torque)

	$AudioStreamPlayer.play()
	$Particles.amount = $Particles.amount - 1
	$Particles.amount = $Particles.amount + 1
	$Particles.emitting = true
	get_parent().apply_central_impulse(Vector3(0, 1, 0) * jumpImpulse)
	yield(get_tree().create_timer(0.05), "timeout")
	get_node("../Position3D/TPScam").shake()

func falloff(d, factor):
	return (1.0 - pow(d, factor))
