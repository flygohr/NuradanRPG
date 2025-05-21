extends Node2D

func _ready() -> void:
	# creating custom "area detection" shape at runtime to account for different area shapes
	var mapGround := %Ground
	var mapArea := %"Map Area"
	# read map size
	var mapSize = mapGround.get_used_rect().size
	# print map size
	print(mapSize.x)
	print(mapSize.y)
	# create collision shape
	var mapAreaCollision := CollisionShape2D.new()
	var mapAreaCollisionShape := RectangleShape2D.new()
	mapAreaCollision.debug_color = Color(0.65,0.5,0.1,0.3)
	mapAreaCollisionShape.size = Vector2(mapSize.x*Globals.TILE_SIZE, mapSize.y*Globals.TILE_SIZE)
	mapAreaCollision.position = Vector2((mapSize.x*Globals.TILE_SIZE)/2, (mapSize.y*Globals.TILE_SIZE)/2)
	mapAreaCollision.shape = mapAreaCollisionShape
	mapArea.add_child(mapAreaCollision)


func _on_map_area_area_entered(area: Area2D) -> void:
	if area is PlayerArea:
		print("Player entered area " + str(self.name))
		# I should load connected chunks here
		# I should play the UI area name thing here

func _on_map_area_area_exited(area: Area2D) -> void:
	if area is PlayerArea:
		await get_tree().create_timer(3).timeout
		print("Player exited area " + str(self.name))
		# I should de-load connected chunks here
