extends Node2D

@export var target_map: Globals.ZONE_NAMES


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PlayerArea:
		print_debug("Player has entered warp to ", Globals.ZONE_NAMES.keys()[target_map])
		SignalBus.warp_entered.emit() #TODO start scene transition instead of abrupt
