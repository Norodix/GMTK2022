extends Spatial

export var impulseCenter = 10
export var falloffFactor = 2
export var verticlBias = 2
export var biasFalloff = 3

var maxDistance

# Called when the node enters the scene tree for the first time.
func _ready():
	maxDistance = $Area/CollisionShape.shape.radius
	print("Max distance of explosion: ", maxDistance)
	pass # Replace with function body.


func explode():
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

func falloff(d, factor):
	return (1.0 - pow(d, factor))
