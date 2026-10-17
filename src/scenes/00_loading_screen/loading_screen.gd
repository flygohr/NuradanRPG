extends CanvasLayer

signal loading_screen_ready

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	await animation_player.animation_finished
	loading_screen_ready.emit()
	
func _on_progress_changed(_new_value: float) -> void:
	# Could put a progress bar here
	pass

func _on_load_finished() -> void:
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	queue_free()
