extends TileMapLayer

@onready var grass_tall_scene = preload("uid://dctbwjndfn6bc")
@onready var wheat_scene = preload("uid://kuy3e7vuhrmn")

func _ready():
	find_and_spawn_interactive_tiles()

func find_and_spawn_interactive_tiles():
	var tilemap_data = get_used_cells()
	for tile_coords in tilemap_data:
		var tile_data := get_cell_tile_data(tile_coords)
		match tile_data.get_custom_data("tileType"):
			"grass_tall":
				set_cell(tile_coords, -1)
				var grass_tall = grass_tall_scene.instantiate()
				var pos = map_to_local(tile_coords)
				grass_tall.position = Vector2(pos.x-8, pos.y+8)
				call_deferred("add_child", grass_tall)
			"wheat":
				set_cell(tile_coords, -1)
				var wheat = wheat_scene.instantiate()
				var pos = map_to_local(tile_coords)
				wheat.position = Vector2(pos.x-8, pos.y+8)
				call_deferred("add_child", wheat)
			_:
				continue
