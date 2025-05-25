extends Node2D
class_name Zone

@export var connected_zones: Dictionary[String, Vector2]

var area_increase := 4 # Extra tiles inbetween zones detection (for preloading and waiting to deload)

func _ready() -> void:
	create_area()

func _on_map_area_area_entered(area: Area2D) -> void:
	if area is PlayerArea:
		print("Player entered area " + str(self.name))
		SignalBus.zone_changed.emit(scene_file_path)

## Returns the dictionary of adjacent zones
func get_connected_zones() -> Dictionary[String, Vector2]:
	return connected_zones

func create_area():
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
	mapAreaCollisionShape.size = Vector2((mapSize.x+area_increase)*Globals.TILE_SIZE, (mapSize.y+area_increase)*Globals.TILE_SIZE)
	mapAreaCollision.position = Vector2((mapSize.x*Globals.TILE_SIZE)/2, (mapSize.y*Globals.TILE_SIZE)/2)
	mapAreaCollision.shape = mapAreaCollisionShape
	mapArea.call_deferred("add_child", mapAreaCollision)
