extends Sprite2D

@onready var _animation_player = $AnimationPlayer
@onready var rayCast = $RayCast2D
@onready var frontCheck = $FrontCheck


enum playerStates { IDLE, TURNING, WALKING }
const MOVEMENTS = {
	'ui_up': Vector2.UP,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT,
	'ui_down': Vector2.DOWN,
}
var direction_history = []

var currentPlayerState = playerStates.IDLE
var currentFacingDirection : Vector2 = Vector2.DOWN

var inputDirection : Vector2
var isMoving = false
var moveSpeed : float = 0.1

var holdCounter
var holdTime = 20

func _ready() -> void: 
	_animation_player.play("idleDown")

func _physics_process(delta: float) -> void:
	holdManager()
	inputDirection = Vector2.ZERO

	# loop through all the directions ('ui_up', ui_left', etc),
	# check to see if a key has been released, and if so, we
	# want to remove it from the array holding all the pressed keys
	for direction in MOVEMENTS.keys():
		if Input.is_action_just_released(direction):
			var index = direction_history.find(direction)
			if index != -1:
				direction_history.remove_at(index)
		if Input.is_action_just_pressed(direction):
			direction_history.append(direction)

	if direction_history.size():
		var direction = direction_history[direction_history.size() - 1]
		inputDirection = MOVEMENTS[direction]

	if inputDirection == Vector2.ZERO: return # don't do anything if there's no input
	
	if !currentFacingDirection.is_equal_approx(inputDirection):
		updateFacingDirection()
	else:
		move()

func holdManager():
	if inputDirection != Vector2.ZERO:
		holdCounter += 1
	else: holdCounter = 0
	
	if holdCounter > holdTime: return true
	else: return false

func move():
	if inputDirection:
		if isMoving == false and !rayCast.is_colliding() and holdManager():
			isMoving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position+inputDirection*Globals.TILE_SIZE, moveSpeed)
			tween.tween_callback(stopMoving)
			
func stopMoving():
	isMoving = false

func updateFacingDirection():
	if inputDirection == Vector2.UP:
		_animation_player.play("idleUp")
		currentFacingDirection = inputDirection
		rayCast.target_position.x = 0
		rayCast.target_position.y = -Globals.TILE_SIZE
		frontCheck.position.x = 0
		frontCheck.position.y = -(Globals.TILE_SIZE*2)
	elif inputDirection == Vector2.RIGHT:
		_animation_player.play("idleRight")
		currentFacingDirection = inputDirection
		rayCast.target_position.x = Globals.TILE_SIZE
		rayCast.target_position.y = 0
		frontCheck.position.x = Globals.TILE_SIZE
		frontCheck.position.y = -Globals.TILE_SIZE
	elif inputDirection == Vector2.DOWN:
		_animation_player.play("idleDown")
		currentFacingDirection = inputDirection
		rayCast.target_position.x = 0
		rayCast.target_position.y = Globals.TILE_SIZE
		frontCheck.position.x = 0
		frontCheck.position.y = 0
	elif inputDirection == Vector2.LEFT:
		_animation_player.play("idleLeft")
		currentFacingDirection = inputDirection
		rayCast.target_position.x = -Globals.TILE_SIZE
		rayCast.target_position.y =  0
		frontCheck.position.x = -Globals.TILE_SIZE
		frontCheck.position.y = -Globals.TILE_SIZE
