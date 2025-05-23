extends Node2D
class_name GameMap

@onready var connections := $Connections

var area_increase := 4

func _ready() -> void:
	create_area()

func _on_map_area_area_entered(area: Area2D) -> void:
	if area is PlayerArea:
		print("Player entered area " + str(self.name))
		load_connections()

func _on_map_area_area_exited(area: Area2D) -> void:
	if area is PlayerArea:
		print("Player exited area " + str(self.name))
		unload_connections()

func load_connections():
	print("Loading connections for " + str(self.name) + " here")
	for connection in connections.get_children():
		# getting connection data
		var offset_x := int(connection.offset_x*Globals.TILE_SIZE*Globals.CHUNK_SIZE)
		var offset_y = int(connection.offset_y*Globals.TILE_SIZE*Globals.CHUNK_SIZE)
		var position_x := int(connection.position.x)
		var position_y := int(connection.position.y)

		print("Area " + str(self.name) + " connects with " + str(connection.name) +  " starting at position " + str(position_x) + ", " + str(int(position_y)) + ", with offset X " + str(offset_x) + " and offset Y " + str(offset_y))
		
		# load the resource
		print("This is the connection: " + str(connection))
		var connected_map_scene = load(connection.connection.resource_path) # giant bug here, idk why it crashes when changing map
		var connected_map = connected_map_scene.instantiate()
		# print(connection.connection.resource_path)
		connected_map.position = to_global(Vector2i(position_x+offset_x,position_y+offset_y))
		Navigation.load_connection(connected_map)
	print("Loading connections for " + str(self.name) + " here")

func unload_connections():
	print("Unloading connections for " + str(self.name) + " here")

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
	mapArea.add_child(mapAreaCollision)
