extends TileMapLayer

func _ready() -> void:
	var area = get_used_rect().size
	print(area.y)
	
	for r in 8:
		for x in (area.x+(r*2)):
			set_cell(Vector2i(x-r,-r),0,Vector2i(1,0))
				
	
	# here I need to loop and go around the map 4 times
