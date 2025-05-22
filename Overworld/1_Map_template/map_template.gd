extends Node2D

@onready var connections := %Connections

func _ready() -> void:
	# creating custom "area detection" shape at runtime to account for different area shapes
	var mapGround := %Ground
	var mapArea := %"Map Area"
	# read map size
	var mapSize = mapGround.get_used_rect().size
	# print map size
	print("Area " + str(self.name) + " is " + str(mapSize.x) + " tiles wide")
	print("Area " + str(self.name) + " is " + str(mapSize.y) + " tiles tall")

	# create collision shape
	var mapAreaCollision := CollisionShape2D.new()
	var mapAreaCollisionShape := RectangleShape2D.new()
	mapAreaCollision.debug_color = Color(0.65,0.5,0.1,0.3)
	mapAreaCollisionShape.size = Vector2((mapSize.x+6)*Globals.TILE_SIZE, (mapSize.y+6)*Globals.TILE_SIZE)
	mapAreaCollision.position = Vector2((mapSize.x*Globals.TILE_SIZE)/2, (mapSize.y*Globals.TILE_SIZE)/2)
	mapAreaCollision.shape = mapAreaCollisionShape
	mapArea.add_child(mapAreaCollision)


func _on_map_area_area_entered(area: Area2D) -> void:
	if area is PlayerArea:
		print("Player entered area " + str(self.name))
		# I should load connected chunks here
		load_connections()
		print("This is : " + str(self))
		#Navigation.remove_area_from_connections_list(self) # keeps the area upon deloading other areas
		# check the resourceloader thing
		# learn the damn signals so I can have a black transition upon starting to wait for all areas to load
		# https://www.reddit.com/r/godot/comments/1kr93lx/comment/mtdjpt4/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
		# I should play the UI area name thing here

func _on_map_area_area_exited(area: Area2D) -> void:
	if area is PlayerArea:
		print("Player exited area " + str(self.name))
		unload_connections()
		# I should de-load connected chunks here

func load_connections():
	print("Loading " + str(self.name) + " connections")
	# need to loop through markers here
	var connections_list = connections.get_children()
	var parent = self.get_parent()
	for connection in connections_list:
		# getting connection data
		var offset_x := int(connection.offset_x*Globals.TILE_SIZE*Globals.CHUNK_SIZE)
		var offset_y = int(connection.offset_y*Globals.TILE_SIZE*Globals.CHUNK_SIZE)
		var position_x := int(connection.position.x)
		var position_y := int(connection.position.y)

		print("Area " + str(self.name) + " connects with " + str(connection.name) +  " starting at position " + str(position_x) + ", " + str(int(position_y)) + ", with offset X " + str(offset_x) + " and offset Y " + str(offset_y))
		
		# load the resource
		print("This is the connection: " + str(connection))
		var connected_map_loader = ResourceLoader.load_threaded_request(connection.connection.resource_path)
		var connected_map = ResourceLoader.load_threaded_get(connection.connection.resource_path).instantiate()
		# print(connection.connection.resource_path)
		connected_map.position = Vector2i(position_x+offset_x,position_y+offset_y) #this should be global
		parent.add_child(connected_map)
		Navigation.add_area_to_connections_list(connected_map)
	print("This is the current connections list: " + str(Navigation.current_connections_list))

func unload_connections():
	print("Unloading connections for " + str(self.name) + " here")
	# need to unload everything but the one I traveled to
	
	for area in Navigation.current_connections_list:
		print("Currently unloading this area: " + str(area))
		area.unload_self()
		
	Navigation.current_connections_list = []

func unload_self():
	queue_free()
