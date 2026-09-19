extends Camera2D

func _process(_delta) -> void:
	zoom.x = Globals.CAMERA_ZOOM
	zoom.y = Globals.CAMERA_ZOOM
	#TODO: use setters and getters to avoid process here
