extends Sprite2D

class_name Player

@onready var animTree = $AnimationTree
@onready var animState = animTree.get("parameters/playback")
@onready var rayCast = $RayCast2D
@onready var frontCheckBox = $FrontCheck

enum playerStates { IDLE, TURNING, WALKING }
enum facingDirections { LEFT, RIGHT, UP, DOWN }

var currentPlayerState = playerStates.IDLE
var currentFacingDirection = facingDirections.DOWN

var initialPosition = Vector2(0, 0)
var inputDirection = Vector2(0, 0)
var isMoving = false
var percentMovedToNextTile = 0.0

# Keep track of the latest direction the player wants to move to
var latestDirection = null
var holdCounter := 0.0
var idleCounter := 0.0
var holdTarget := 0.2

# Utility mapping from direction to vector
const MOVEMENTS = {
	facingDirections.UP: Vector2.UP,
	facingDirections.LEFT: Vector2.LEFT,
	facingDirections.RIGHT: Vector2.RIGHT,
	facingDirections.DOWN: Vector2.DOWN,
 }

func _ready():
	animTree.active = true
	initialPosition = position

func _physics_process(delta):
	if idleCounter >= holdTarget: # resets holdCounter if idle for long
		holdCounter = 0.0
		idleCounter = 0.0
	# First we register which direction the player intents to move to
	if Input.is_action_just_pressed("ui_left"):
		latestDirection = facingDirections.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		latestDirection = facingDirections.RIGHT
	elif Input.is_action_just_pressed("ui_down"):
		latestDirection = facingDirections.DOWN
	elif Input.is_action_just_pressed("ui_up"):
		latestDirection = facingDirections.UP

	# If they release a button, they cancel their intent
	if Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_down"):
		latestDirection = null
		
	if currentPlayerState == playerStates.TURNING:
		return
	elif isMoving == false:
		process_player_input(delta)
	elif inputDirection != Vector2.ZERO:
		animState.travel("Walk")
		move(delta)
	else:
		animState.travel("Idle")
		isMoving = false

func change_front_check_position(dir):
	match dir:
		Vector2.UP:
			frontCheckBox.position = Vector2(0, -32)
		Vector2.RIGHT:	
			frontCheckBox.position = Vector2(16, -16)
		Vector2.DOWN:	
			frontCheckBox.position = Vector2(0, 0)
		Vector2.LEFT:	
			frontCheckBox.position = Vector2(-16, -16)

func process_player_input(delta):

	if inputDirection.y == 0:
		inputDirection.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if inputDirection.x == 0:
		inputDirection.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	# If the player had intent to move, use that instead of the "outdated" inputDirection
	if latestDirection != null:
		inputDirection = MOVEMENTS[latestDirection]

	if inputDirection != Vector2.ZERO:
		animTree.set("parameters/Idle/blend_position", inputDirection)
		animTree.set("parameters/Walk/blend_position", inputDirection)
		animTree.set("parameters/Turn/blend_position", inputDirection)
		change_front_check_position(inputDirection)
		if need_to_turn() and holdCounter <= holdTarget:
			currentPlayerState = playerStates.TURNING
			animState.travel("Turn")
		else:
			initialPosition = position
			isMoving = true
	else:
		animState.travel("Idle")
		idleCounter += delta

func need_to_turn():
	var newCurrentFacingDirection
	if inputDirection.x < 0:
		newCurrentFacingDirection = facingDirections.LEFT
	elif inputDirection.x > 0:
		newCurrentFacingDirection = facingDirections.RIGHT
	elif inputDirection.y < 0:
		newCurrentFacingDirection = facingDirections.UP
	elif inputDirection.y > 0:
		newCurrentFacingDirection = facingDirections.DOWN
	if currentFacingDirection != newCurrentFacingDirection:
		currentFacingDirection = newCurrentFacingDirection
		return true
	else:
		currentFacingDirection = newCurrentFacingDirection
		return false

func finished_turning():
	currentPlayerState = playerStates.IDLE

func move(delta):
	holdCounter += delta
	var desiredStep: Vector2 = inputDirection * Globals.TILE_SIZE / 2
	rayCast.target_position = desiredStep
	rayCast.force_raycast_update()
	if !rayCast.is_colliding():
		percentMovedToNextTile += Globals.PLAYER_SPEED * delta
		if percentMovedToNextTile >= 1.0:
			position = initialPosition + (Globals.TILE_SIZE * inputDirection)
			percentMovedToNextTile = 0.0
			isMoving = false
		else:
			position = initialPosition + (Globals.TILE_SIZE * inputDirection * percentMovedToNextTile)
	else:
		percentMovedToNextTile = 0.0
		isMoving = false
