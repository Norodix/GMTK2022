extends Control

onready var playButton = find_node("Play")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	playButton.grab_focus()
	pass # Replace with function body.


func _on_Play_pressed():
	print("Play button pressed")
	get_tree().change_scene("res://World.tscn")
	pass # Replace with function body.


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	print("Exiting normally from main menu")
	get_tree().quit(0)
	pass # Replace with function body.
