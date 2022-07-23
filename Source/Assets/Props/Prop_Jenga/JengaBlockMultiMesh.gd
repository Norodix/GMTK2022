extends MultiMeshInstance

func _ready():
	var jengas = []
	
	for child in get_parent().get_children():
		if child.is_in_group("JengaBlock"):
			jengas.append(child)
	
	multimesh.instance_count = jengas.size()
	multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_FLOAT
	for i in jengas.size():
		multimesh.set_instance_transform(i, jengas[i].transform)
		var c = float(i)/float(jengas.size());
		multimesh.set_instance_custom_data(i, Color(c, c, c))
		jengas[i].visible = false
	pass # Replace with function body.
