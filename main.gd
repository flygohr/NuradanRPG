extends Node2D

@export var world: Node2D

var thread: Thread # Thread to load adjacent scenes
var loaded_zones: Dictionary[String, Node] = {}  # Dictionary of currently loaded map chunks

func _ready() -> void:
	thread = Thread.new()
	await load_zone("uid://qhvrd0ywc85l")
	SignalBus.zone_changed.connect(change_zone)
	
func change_zone_thread(zone_path : String):
	var zone = load(zone_path).instantiate()
	var connected_zones = zone.get_connected_zones()
	for connection in connected_zones.keys():
		if not connection in loaded_zones:
			var connected_zone = load(connection).instantiate()
			loaded_zones[connection] = connected_zone
			connected_zone.position = zone.position + (connected_zones[connection]*Globals.TILE_SIZE*Globals.CHUNK_SIZE) # this positioning is off, might need to recalculate offsets
			world.call_deferred("add_child", connected_zone)
		print(loaded_zones)
		
func load_zone(path: String):
	var zone = load(path).instantiate()
	loaded_zones[path] = zone
	world.call_deferred("add_child",zone)

func change_zone(zone_path: String) -> void:
	if thread.is_started():
		thread.wait_to_finish()
	thread.start(change_zone_thread.bind(zone_path))
