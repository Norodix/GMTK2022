extends Spatial


func _ready():
	$RotateBounce.play("RotateBounce")
	pass # Replace with function body.


func _on_Area_body_entered(body):
	CheckPointSingleton.checkpoint = self.global_transform
	$AudioStreamPlayer.play()
	pass # Replace with function body.
