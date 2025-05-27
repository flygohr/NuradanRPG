extends Node2D

@export var world: Node2D

var thread: Thread # Thread to load adjacent scenes
var loaded_zones: Dictionary[String, Node] = {}  # Dictionary of currently loaded map chunks
var current_zone

func _ready() -> void:
	thread = Thread.new()
	await load_zone("uid://qhvrd0ywc85l")
	SignalBus.zone_changed.connect(change_zone)
	
func change_zone_thread(zone_uid : String):
	var connected_zones = current_zone.get_connected_zones()
	for connection in connected_zones.keys():
		if not connection in loaded_zones:
			var connected_zone = load(connection).instantiate()
			loaded_zones[connection] = connected_zone
			connected_zone.position = current_zone.position + Vector2(connected_zones[connection].x*Globals.TILE_SIZE*Globals.CHUNK_SIZE, connected_zones[connection].y*Globals.TILE_SIZE*Globals.CHUNK_SIZE) # this positioning is off, might need to recalculate offsets
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
