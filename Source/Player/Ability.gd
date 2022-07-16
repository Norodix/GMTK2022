extends Spatial
class_name Ability
tool

export(int) var id = -1
export(String, "jump", "dash", "explode", "random") var callback = "random"

func _ready():
	pass # Replace with function body.


func _process(delta):
	$MeshInstance.visible = Engine.is_editor_hint()
	pass


func get_global_normal():
	return self.global_transform.basis * Vector3.UP
