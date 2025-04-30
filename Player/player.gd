extends CharacterBody2D

func _input(event):
	if event.is_action_pressed("ui_right"):
		position.x += Globals.TILE_SIZE
		
	if event.is_action_pressed("ui_left"):
		position.x -= Globals.TILE_SIZE
		
	if event.is_action_pressed("ui_up"):
		position.y -= Globals.TILE_SIZE
		
	if event.is_action_pressed("ui_down"):
		position.y += Globals.TILE_SIZE
