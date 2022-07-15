extends Control

onready var ResumeButton = find_node("Resume")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		if not get_tree().paused:
			pauseGame()
		else:
			resumeGame()
		
	self.visible = get_tree().paused
	Engine.time_scale = float(int(not get_tree().paused))
	
func _on_Resume_pressed():
	resumeGame()
	pass # Replace with function body.

func _on_Exit_pressed():
	resumeGame()
	get_tree().change_scene("res://UI/Menu.tscn")
	pass # Replace with function body.

func pauseGame():
	get_tree().paused = true
	ResumeButton.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func resumeGame():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
