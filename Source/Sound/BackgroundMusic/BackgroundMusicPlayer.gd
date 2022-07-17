extends Node

onready var player :AudioStreamPlayer = AudioStreamPlayer.new()
var music : AudioStream

func _ready():
	music = load("res://Sound/BackgroundMusic/1 with tail.wav")
	print("Background music player ready, music: ", music)
	get_tree().get_root().call_deferred("add_child", player)
	player.bus = "Music"
	player.set_stream(music)
	player.connect("finished", self, "play_next_loop")
	player.set_volume_db(0)
	player.play()
	pass # Replace with function body.


func _process(delta):
	#print(player.playing)
	pass


func play_next_loop():
	yield(get_tree().create_timer(1.5), "timeout")
	player.play()
	pass
