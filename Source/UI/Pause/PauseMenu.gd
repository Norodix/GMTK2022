extends Control

onready var ResumeButton = get_node("CenterContainer/VBoxContainer2/Resume")
var resume_game = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		resume_game = true
		
	if resume_game:
		if not get_tree().paused:
			pauseGame()
		else:
			resumeGame()
		
	self.visible = get_tree().paused
	Engine.time_scale = float(int(not get_tree().paused))
	
func _on_Resume_pressed():
	resume_game = true
	pass # Replace with function body.

func _on_Exit_pressed():
	resume_game = true
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://UI/MainMenu/Menu.tscn")
	pass # Replace with function body.

func pauseGame():
	resume_game = false
	get_tree().paused = true
	ResumeButton.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func resumeGame():
	resume_game = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass


func _on_Respawn_pressed():
	resume_game = true
	yield(get_tree().create_timer(0.3), "timeout")
	CheckPointSingleton.respawn()
	pass # Replace with function body.
