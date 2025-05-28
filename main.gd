extends Node2D

@export var world: Node2D

# Big thanks to u/_mday from Reddit and their project https://github.com/m-mayday/godmon
#TODO Unload maps on exit, could call area exited with the area currently being exited, check for areas no longer needed?

var thread: Thread # Thread to load adjacent scenes
var loaded_zones: Dictionary[String, Node] = {}  # Dictionary of currently loaded map chunks
var current_zone

func _ready() -> void:
	thread = Thread.new()
	await load_zone("uid://qhvrd0ywc85l")
	SignalBus.zone_changed.connect(change_zone)
	# SignalBus.zone_left.connect(unload_zones)
	
func change_zone_thread(zone_uid : String):
	
	current_zone = loaded_zones[zone_uid]
	var new_connected_zones = current_zone.get_connected_zones()
	
	# Here, unload any old connection that is NOT in the new connections
	
	for uid in loaded_zones.keys():
		if uid not in new_connected_zones.keys() and uid != ResourceUID.id_to_text(ResourceLoader.get_resource_uid(current_zone.scene_file_path)):
			var chunk: Node = loaded_zones[uid]
			loaded_zones.erase(uid)
			chunk.queue_free()
	
	loaded_zones[zone_uid] = current_zone
	
	for uid in new_connected_zones.keys():
		if not uid in loaded_zones:
			var connected_zone = load(uid).instantiate()
			loaded_zones[uid] = connected_zone
			connected_zone.position = current_zone.position + Vector2(new_connected_zones[uid].x*Globals.TILE_SIZE*Globals.CHUNK_SIZE, new_connected_zones[uid].y*Globals.TILE_SIZE*Globals.CHUNK_SIZE) # this positioning is off, might need to recalculate offsets
			world.call_deferred("add_child", connected_zone)
	
func load_zone(zone_uid: String):
	current_zone = load(zone_uid).instantiate()
	loaded_zones[zone_uid] = current_zone
	world.call_deferred("add_child",current_zone)
	if thread.is_started():
		thread.wait_to_finish()
	thread.start(change_zone_thread.bind(zone_uid))

func change_zone(zone_uid: String) -> void:
	if thread.is_started():
		thread.wait_to_finish()
	thread.start(change_zone_thread.bind(zone_uid))
