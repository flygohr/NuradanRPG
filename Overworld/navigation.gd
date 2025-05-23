extends Node

var current_connections_list := []  # a list of all the areas that currently need to be displayed, their position already globalized by the maps themselves

func load_connection(resource_path): # loads unique resource paths to later load as maps?
	if !current_connections_list.has(resource_path):
		current_connections_list.append(resource_path)
	else: return
	
func unload_connection(resource_path): # unloads a resource path only if it's not in the active list
	current_connections_list.erase(resource_path)

func _physics_process(delta: float) -> void:
	# load threads here
	pass
