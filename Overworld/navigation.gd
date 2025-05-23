extends Node

var current_connections_list := [] # list of instances or nodes currently being displayed, and their global positioning.
var main

func _ready() -> void:
	# print("Getting the parent node from which to spawn and despawn maps")
	main = get_node("/root/Main")

func load_connection(resource_path): # loads unique resource paths to later load as maps?
	if !current_connections_list.has(resource_path):
		current_connections_list.append(resource_path)
	else: return
	
func unload_connection(resource_path): # unloads a resource path only if it's not in the active list
	current_connections_list.erase(resource_path)

func _physics_process(_delta: float) -> void:
	#print(current_connections_list)
	if current_connections_list.size():
		for connection in current_connections_list:
			main.add_child(connection)
			print(connection)
			unload_connection(connection)
	
