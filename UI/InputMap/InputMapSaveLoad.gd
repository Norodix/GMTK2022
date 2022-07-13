extends Node


var path : String = "user://InputMap.tres"


func _ready():	
	load_input_map()
	pass


func save_input_map():
	var map : InputMapResource = InputMapResource.new()
	for action in InputMap.get_actions():
		map.input_map[action] = InputMap.get_action_list(action)
	
	print("Saving input map")
	var saveOK = ResourceSaver.save(path, map)
	print("Save result: ", saveOK)


func load_input_map():
	var map = ResourceLoader.load(path, "InputMapResource")
	
	if not map:
		print("Custom input map not found")
		return
	else:
		print("Loading custom input map from ", path)
	
	for action in map.input_map:
		InputMap.action_erase_events(action)
		for event in map.input_map[action]:
			InputMap.action_add_event(action, event)
	pass

