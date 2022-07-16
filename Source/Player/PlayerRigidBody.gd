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
var ability_jump_impulse = 10
onready var ability_dash_angle = deg2rad(20)
var ability_dash_impulse = 10

var last_velocity = Vector3.ZERO
var last_acceleration = Vector3.ZERO
var average_jerk = Vector3.ZERO
var canPlay = true
var knock_min_jerk = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


func _process(delta):
	handle_debug_inputs()
	pass


func _physics_process(delta):
	inputDir = Input.get_vector("Left", "Right", "Up", "Down")
	forwardDir = get_horizontal_look_direction()
	
	if Input.is_action_just_pressed("Jump"):
		if $jumpCooldown.is_stopped():
			$jumpCooldown.start()
			apply_central_impulse(Vector3.UP * 2)
	
	if Input.is_action_just_pressed("Ability"):
		if active_ability:
			call(active_ability.callback)
			active_ability = null
		pass
	
	var acc = (last_velocity - self.linear_velocity) / delta
	var jerk = (acc - last_acceleration) / delta
	last_velocity = self.linear_velocity
	last_acceleration = acc
	average_jerk = lerp(average_jerk, jerk, 0.2)
	if average_jerk.length() > knock_min_jerk:
		knockSound()

func knockSound():
	var knockplayer : AudioStreamPlayer = $Knock
	var maxDB = 30
	var maxJerk = 2000
	var dbOffset = -30
	
	if knockplayer.playing == false:
		# map from 0 to 6db based on jerk
		var j = clamp(average_jerk.length(), knock_min_jerk, maxJerk) - knock_min_jerk
		var db = j / (maxJerk - knock_min_jerk) * maxDB
		var pitch = 1 + db/maxDB /2
		db += dbOffset
				
		knockplayer.pitch_scale = pitch
		knockplayer.volume_db = db
		knockplayer.play()


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
		# touching some ground thing, update ability
		update_ability()
	
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


func jump():
	print("jump")
	apply_central_impulse(Vector3.UP * ability_jump_impulse)


func dash():
	var forward = get_horizontal_look_direction()
	var sideways : Vector3 = Vector3.UP.cross(forward)
	var dir : Vector3 = Vector3.ZERO
	if inputDir.length() > 0.1:
		dir = (forward * inputDir.y + sideways * inputDir.x).normalized()
	else:
		dir = - get_horizontal_look_direction()
	# add vertical component so that the angle mathces the config
	# vert/horiz = tan(angle) -> tan(angle) * horiz = vert
	dir.y = tan(ability_dash_angle)
	dir = dir.normalized()
	apply_central_impulse(dir * ability_dash_impulse)
	print("dash")


func explode():
	$ExplosionHandler.explode()
	print("explode")


func random():
	print("random")
	var pool = ["jump", "dash", "explode"]
	call(pool[randi() % 3])


func update_ability():
	var a = find_ability()
	if a != active_ability:
		print(a.id)
	active_ability = a
	highlightAbility(a.id)


func highlightAbility(id):
	var m : Material = $MeshInstance.get_active_material(0).next_pass
	
	m.set_shader_param("mask1_enabled", id == 1)
	m.set_shader_param("mask2_enabled", id == 2)
	m.set_shader_param("mask3_enabled", id == 3)
	m.set_shader_param("mask4_enabled", id == 4)


func get_horizontal_look_direction() -> Vector3:
	var dir = $Position3D/TPScam.global_transform.basis.z
	dir.y = 0
	dir = dir.normalized()
	return dir


func handle_debug_inputs():
	if Input.is_action_just_pressed("jump_debug"):
		jump()
	if Input.is_action_just_pressed("dash_debug"):
		dash()
	if Input.is_action_just_pressed("explode_debug"):
		explode()
		
		


func _on_PlayerRigidBody_body_entered(body):
	#$RandomAudioStreamPlayer3D.play()
	pass # Replace with function body.
