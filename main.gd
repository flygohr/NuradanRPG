extends Node2D

@export var world: Node

var thread: Thread # Thread to load adjacent zones
var current_zone: Node # The current scene loaded
var _loaded_zones: Dictionary[String, Node] = {}

func _ready() -> void:
	thread = Thread.new()
	await load_zone("uid://qhvrd0ywc85l")
	SignalBus.entered_zone.connect(_change_zone) # upon entering area, change scene is called. if called, it checks what to do. i'll just update scenes here
	
func load_zone(zone_path: String):
	current_zone = load(zone_path).instantiate()
	world.add_child(current_zone)

## Changes the current scene with a new adjacent one
## and it updates the adjacent scenes
func _change_zone(new_zone_path: String) -> void:
	#print("change zones 1")
	#if new_zone_path == current_zone.scene_file_path or new_zone_path not in _loaded_zones.keys():
		#return  # Already the current scene

	# current_zone = _loaded_zones[new_zone_path]
	_update_connected_zones(current_zone)
	print("change zones 2")


## Frees scenes that are not adjacent to the new scene
## Calls _load_adjacent_scenes in a thread
func _update_connected_zones(new_zone: Variant) -> void:
	if not new_zone.has_method("get_connected_zones"):
		return
		
	var new_connected_zones: Dictionary[String, Vector2] = new_zone.get_connected_zones()

	# Unload scenes that are no longer adjacent
	for path in _loaded_zones.keys():
		if path not in new_connected_zones.keys() and path != new_zone.scene_file_path:
			var chunk: Node = _loaded_zones[path]
			_loaded_zones.erase(path)
			chunk.queue_free()
			
	if thread.is_started():
		thread.wait_to_finish()
	thread.start(_load_connected_zones.bind(new_zone)) # Load adjacent scenes in thread

## Loads adjacent scenes given the current scene and adds them to _loaded_chunks
func _load_connected_zones(new_zone: Variant) -> void:
	if not new_zone.has_method("get_connected_zones"):
		return
		
	var connected_zones: Dictionary[String, Vector2] = new_zone.get_connected_zones()

	for zone in connected_zones:
		if zone not in _loaded_zones:
			var chunk: Variant = load(zone).instantiate()
			chunk.position = new_zone.position + connected_zones[zone]
			world.call_deferred("add_child", chunk)
			# connected_zones[zone] = chunk
