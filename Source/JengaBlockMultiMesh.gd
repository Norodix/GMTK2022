extends MultiMeshInstance

func _ready():
	var jengas = []
	$MultiMeshInstance.visible = true
	for child in get_children():
		if child is Node:
			if child.is_in_group("JengaBlock"):
				jengas.append(child)
	
	$MultiMeshInstance.multimesh.instance_count = jengas.size()
	$MultiMeshInstance.multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_FLOAT
	for i in jengas.size():
		$MultiMeshInstance.multimesh.set_instance_transform(i, jengas[i].transform)
		var c = float(i)/float(jengas.size());
		$MultiMeshInstance.multimesh.set_instance_custom_data(i, Color(c, c, c))
		#$MultiMeshInstance.multimesh.set_instance_color(i, Color(c, c, c))
		print(c)
		jengas[i].visible = false
	pass # Replace with function body.
