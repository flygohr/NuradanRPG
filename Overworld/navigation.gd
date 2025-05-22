extends Node

@onready var current_connections_list := []

func add_area_to_connections_list(area):
	current_connections_list.append(area)
	
func remove_area_from_connections_list(area):
	current_connections_list.erase(area)
	# erase doesn't work. I need to specify the EXACT map to remove, maybe with a method inside itself.
	
# this script should contain a list of maps to load, their global positioning, make sure they are unique, and call their own loading and unloading when needed?

func _physics_process(delta: float) -> void:
	if current_connections_list.size():
		pass # here I should load threading
