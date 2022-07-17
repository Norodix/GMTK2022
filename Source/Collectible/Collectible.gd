extends Spatial

signal pickup

func _ready():
	pass # Replace with function body.


func _on_Area_body_entered(body):
	emit_signal("pickup", self)
	pass # Replace with function body.
