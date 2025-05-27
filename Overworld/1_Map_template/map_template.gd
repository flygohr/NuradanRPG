extends Node2D
class_name Zone

#TODO finish creating matches here

@export var connected_zones: Dictionary[Globals.ZONE_NAMES, Vector2i]

func _ready() -> void:
	create_area(Globals.ZONE_DETECTION_AREA_INCREASE) # Creates the collission box that covers the entire map

func _on_map_area_area_entered(area: Area2D) -> void: # Outputs the UID of the zone to be used for loading
	if area is PlayerArea:
		print("Player entered area " + str(self.name))
		SignalBus.zone_changed.emit(ResourceUID.id_to_text(ResourceLoader.get_resource_uid(scene_file_path)))

# Returns the dictionary of adjacent zones UIDs and offsets
func get_connected_zones() -> Dictionary[String, Vector2i]:
	var connected_zones_dict : Dictionary[String, Vector2i]
	for connection in connected_zones.keys():
		connected_zones_dict[Globals.ZONE_UIDS[connection]] = connected_zones[connection]
	return connected_zones_dict

func create_area(increase : int) -> void:
	# creating custom "area detection" shape at runtime to account for different area shapes
	var mapGround := $Ground
	var mapArea := $"Map Area"
	# read map size
	var mapSize = mapGround.get_used_rect().size
	# print map size
	# print("Area " + str(self.name) + " is " + str(mapSize.x) + " tiles wide")
	# print("Area " + str(self.name) + " is " + str(mapSize.y) + " tiles tall")

	# create collision shape with extra size to give room to preloading
	var mapAreaCollision := CollisionShape2D.new()
	var mapAreaCollisionShape := RectangleShape2D.new()
	mapAreaCollision.debug_color = Color(0.65,0.5,0.1,0.3)
	mapAreaCollisionShape.size = Vector2i((mapSize.x+(increase*2))*Globals.TILE_SIZE, (mapSize.y+(increase*2))*Globals.TILE_SIZE)
	mapAreaCollision.position = Vector2i((mapSize.x*Globals.TILE_SIZE)/2, (mapSize.y*Globals.TILE_SIZE)/2)
	mapAreaCollision.shape = mapAreaCollisionShape
	mapArea.call_deferred("add_child", mapAreaCollision)
