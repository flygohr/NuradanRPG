extends Node2D

# map loading
# basically read what map and position I'm in from save and load that first 
# then loop over the various connections, load them, and position them depending on their size and placement
# upon moving to a new map, do the same? idk how loading and unloading should really work, I'm worried about edge cases where I travel to a corner?



@onready var secondMap := preload("res://Overworld/overworld.tscn")

#func _ready() -> void:
	#var secondMapInstance = secondMap.instantiate()
	#add_child(secondMapInstance)
	#secondMapInstance.position = Vector2(0,-24*Globals.TILE_SIZE)
