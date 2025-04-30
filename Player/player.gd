extends Sprite2D

@onready var _animation_player = $AnimationPlayer

enum PlayerState { IDLE, TURNING, WALKING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN


# if idle and action pressed is not facing direction -> turn on the spot
# if idle and action pressed IS facing direction -> move 1
# if idle and action keep pressed -> keep walking 


var hold_counter : float = 0.0
var hold_time : float = 0.1

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		hold_counter += delta
		_animation_player.play("idleUp")
		if facing_direction == FacingDirection.UP and hold_counter >= hold_time:
			position.y -= Globals.TILE_SIZE
		facing_direction = FacingDirection.UP
		hold_counter == 0.0
	
