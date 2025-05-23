extends Node2D

@onready var connections := %Connections

func _ready() -> void:
	# creating custom "area detection" shape at runtime to account for different area shapes
	var mapGround := %Ground
	var mapArea := %"Map Area"
	# read map size
	var mapSize = mapGround.get_used_rect().size
	# print map size
	# print("Area " + str(self.name) + " is " + str(mapSize.x) + " tiles wide")
	# print("Area " + str(self.name) + " is " + str(mapSize.y) + " tiles tall")

	# create collision shape with extra size to give room to preloading
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

func _on_map_area_area_exited(area: Area2D) -> void:
	if area is PlayerArea:
		print("Player exited area " + str(self.name))
		unload_connections()

func load_connections():
	print("Loading connections for " + str(self.name) + " here")

func unload_connections():
	print("Unloading connections for " + str(self.name) + " here")
