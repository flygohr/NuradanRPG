extends Node

var TILE_SIZE = 16

func wait(seconds: float) -> void:
  await get_tree().create_timer(seconds).timeout
