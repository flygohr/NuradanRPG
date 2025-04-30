extends Sprite2D

@onready var _animation_player = $AnimationPlayer
@onready var rayCast = $RayCast2D
@onready var frontCheck = $FrontCheck


enum PlayerState { IDLE, TURNING, WALKING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN


# if idle and action pressed is not facing direction -> turn on the spot
# if idle and action pressed IS facing direction -> move 1
# if idle and action keep pressed -> keep walking 


var hold_counter : float = 0.0
var hold_time : float = 0.3
# hold_counter += delta
# hold_counter == 0.0

# func _physics_process(delta): # delta = reliable way to keep track of time regardless of frames
func _input(event):
	if event.is_action_pressed("ui_up"):
		_animation_player.play("idleUp")
		if facing_direction == FacingDirection.UP and !rayCast.is_colliding():
			position.y -= Globals.TILE_SIZE
		updateFacingDir("up")
		
	elif event.is_action_pressed("ui_right"):
		_animation_player.play("idleRight")
		if facing_direction == FacingDirection.RIGHT and !rayCast.is_colliding():
			position.x += Globals.TILE_SIZE
		updateFacingDir("right")
		
	elif event.is_action_pressed("ui_down"):
		_animation_player.play("idleDown")
		if facing_direction == FacingDirection.DOWN and !rayCast.is_colliding():
			position.y += Globals.TILE_SIZE
		updateFacingDir("down")
		
	elif event.is_action_pressed("ui_left"):
		_animation_player.play("idleLeft")
		if facing_direction == FacingDirection.LEFT and !rayCast.is_colliding():
			position.x -= Globals.TILE_SIZE
		updateFacingDir("left")

func updateFacingDir(direction):
	if direction == "up":
		facing_direction = FacingDirection.UP
		rayCast.target_position.x = 0
		rayCast.target_position.y = -Globals.TILE_SIZE
		frontCheck.position.x = 0
		frontCheck.position.y = -(Globals.TILE_SIZE*2)
	elif direction == "right":
		facing_direction = FacingDirection.RIGHT
		rayCast.target_position.x = Globals.TILE_SIZE
		rayCast.target_position.y = 0
		frontCheck.position.x = Globals.TILE_SIZE
		frontCheck.position.y = -Globals.TILE_SIZE
	elif direction == "down":
		facing_direction = FacingDirection.DOWN
		rayCast.target_position.x = 0
		rayCast.target_position.y = Globals.TILE_SIZE
		frontCheck.position.x = 0
		frontCheck.position.y = 0
	elif direction == "left":
		facing_direction = FacingDirection.LEFT
		rayCast.target_position.x = -Globals.TILE_SIZE
		rayCast.target_position.y =  0
		frontCheck.position.x = -Globals.TILE_SIZE
		frontCheck.position.y = -Globals.TILE_SIZE
