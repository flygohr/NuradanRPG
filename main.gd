extends Node2D

@export var world: Node2D

var thread: Thread # Thread to load adjacent scenes

func _ready() -> void:
	thread = Thread.new()
	await load_zone("uid://qhvrd0ywc85l")
	SignalBus.zone_changed.connect(change_zone)
	
func change_zone(zone_path : String):
	var zone = load(zone_path).instantiate()
	var connected_zones = zone.get_connected_zones()
	for connection in connected_zones.keys():
		var connected_zone = load(connection).instantiate() # this must be threaded
		connected_zone.position = zone.position + connected_zones[connection] # this positioning is off, might need to recalculate offsets
		world.call_deferred("add_child", connected_zone)
		
func load_zone(path: String):
	var zone = load(path).instantiate()
	world.call_deferred("add_child",zone)
