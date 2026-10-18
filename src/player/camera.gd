extends Camera2D

func _ready() -> void:
	SignalBus.camera_zoom_changed.connect(_change_camera_zoom)

func _change_camera_zoom(value) -> void:
	zoom.x = value
	zoom.y = value
	#DONE: use setters and getters to avoid process here
