extends TileMapLayer

func _ready() -> void:
	return
	var area = get_used_rect().size
	
	for r in 8:
		for x in (area.x+(r*2)):
			if (x-r)%2 and r%2:
				set_cell(Vector2i(x-r-1,-r),0,Vector2i(6,0))
				
	
	# here I need to loop and go around the map 4 times
