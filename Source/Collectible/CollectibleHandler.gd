extends Node

onready var collectibleScene = preload("Collectible.tscn")
onready var canvasLayer = CanvasLayer.new()
var pickupScore = 0

onready var player :AudioStreamPlayer = AudioStreamPlayer.new()
onready var music = preload("res://Sound/sfx/success.wav")


func _ready():
	
	self.add_child(canvasLayer)
	
	yield(get_tree().create_timer(0.5), "timeout")
	var positions = get_tree().get_nodes_in_group("CollectiblePositions")
	
	for position in positions:
		var c : Spatial = collectibleScene.instance()
		canvasLayer.add_child(c)
		c.global_transform.origin = position.global_transform.origin
		c.connect("pickup", self, "pickupCallback")
		
	# Create pickup effect player
	get_tree().get_root().call_deferred("add_child", player)
	player.set_stream(music)
	


func pickupCallback(caller):
	pickupScore += 1
	print("Score: ", pickupScore)
	player.play()
	caller.queue_free()
	pass

