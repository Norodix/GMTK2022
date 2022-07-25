extends MultiMeshInstance

func _ready():
	randomize()
	var jengas = []
	
	for child in get_parent().get_children():
		if child.is_in_group("JengaBlock"):
			jengas.append(child)
	
	multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_FLOAT
	multimesh.instance_count = jengas.size()
	for i in jengas.size():
		multimesh.set_instance_transform(i, jengas[i].transform)
		multimesh.set_instance_custom_data(i, Color(randf(), randf(), randf()))
		jengas[i].visible = false
	pass # Replace with function body.
