extends Area2D

@onready var anim_player = $AnimationPlayer
@onready var default_player = $DefaultPlayer

func _ready():
	default_player.play("idle")

func _on_area_entered(area: Area2D) -> void:
	if area is PlayerArea:
		anim_player.play("stepped_grass")

func _on_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
