extends RigidBody

var inputDir : Vector2 = Vector2(0, 0)
var forwardDir : Vector3 = Vector3.ZERO
var mult = 10
onready var mesh = $MeshInstance.mesh
onready var mdt : MeshDataTool = MeshDataTool.new()
var ID = -1
var upface_normal : Vector3 = Vector3.ZERO

var up_limit = 0.7
var active_ability : Ability = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	#find_ability()
#	mdt.create_from_surface(mesh, 0)
#	var newID = get_up_face_id(mdt, Vector3.UP)
#	if ID != newID:
#		ID = newID
#		print("Upwards face: ", ID)
#		var ability = find_ability()
#		print(ability.id)
	pass


func _physics_process(delta):
	inputDir = Input.get_vector("Left", "Right", "Up", "Down")
	forwardDir = $Position3D/TPScam.global_transform.basis.z
	forwardDir.y = 0
	forwardDir = forwardDir.normalized()
	
	if Input.is_action_just_pressed("Jump"):
		if $jumpCooldown.is_stopped():
			$jumpCooldown.start()
			apply_central_impulse(Vector3.UP * 10)
	

func _integrate_forces(state):
	var sideways : Vector3 = Vector3.UP.cross(forwardDir)
	add_central_force(forwardDir * inputDir.y * mult)
	add_central_force(sideways * inputDir.x * mult)
	
	var upNormals = []
	# Get the collision normals
	for c in state.get_contact_count():
		var normal = state.get_contact_local_normal(c)
		if normal.dot(Vector3.UP) > up_limit:
			upNormals.append(normal)
		#var position = state.get_contact_local_position(c)
		#DDD.DrawRay(position, normal, Color(1, 0, 0))
		pass
	
	var sumnormal = Vector3.ZERO
	if not upNormals.empty():
		for n in upNormals:
			sumnormal += n
		sumnormal /= upNormals.size()
		upface_normal = sumnormal
	DDD.DrawRay(self.global_transform.origin, sumnormal, Color(0, 0, 1))

func get_up_face_id(mdt : MeshDataTool, upVector : Vector3) -> int:
	var n = mdt.get_face_count()
	var ID = -1
	var maxAligned = -2
	for i in range(n):
		var normal = mdt.get_face_normal(i)
		normal = $MeshInstance.global_transform.basis * normal
		var alignment = normal.dot(Vector3.UP)
		if alignment > maxAligned:
			maxAligned = alignment
			ID = i
	return ID

func offset_face(mdt : MeshDataTool, id : int):
	var normal = mdt.get_face_normal(id)
	for i in range(3):
		var v_idx = mdt.get_face_vertex(id, i)
		mdt.set_vertex(v_idx, mdt.get_vertex(v_idx) + normal/4)
	mdt.commit_to_surface(mesh)


func find_ability() -> Ability:
	var maxAligned = -2
	var alignedAbility = null
	for ability in $Abilities.get_children():
		var normal = ability.get_global_normal()
		var alignment = normal.dot(upface_normal)
		if alignment > maxAligned:
			maxAligned = alignment
			alignedAbility = ability
	return alignedAbility
	pass


func _on_PlayerRigidBody_body_entered(body):
	var a = find_ability()
	if a != active_ability:
		print(a.id)
	active_ability = a
	pass # Replace with function body.
