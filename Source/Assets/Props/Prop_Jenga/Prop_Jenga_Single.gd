extends StaticBody
export(Gradient) var gradient : Gradient

const defaultColor = Color.burlywood

func _ready():
	randomize()
	var c = defaultColor # color of the jenga
	if gradient != null:
		var i = randi() % gradient.get_point_count()
		c = gradient.get_color(i)
	
	var mat = $Prop_Jenga.get_active_material(0)
	mat.set_shader_param("base_color", c)
	var shadeColor = mat.get_shader_param("shade_color")
	mat.set_shader_param("shade_color", shadeColor * c)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
