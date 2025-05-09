extends Sprite2D

class_name Player

@export var walk_speed = 6.0

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

func _ready():
	animTree.active = true
	initialPosition = position

func _physics_process(delta):
	if currentPlayerState == playerStates.TURNING:
		return
	elif isMoving == false:
		process_player_input()
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

func process_player_input():
	if inputDirection.y == 0:
		inputDirection.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if inputDirection.x == 0:
		inputDirection.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if inputDirection != Vector2.ZERO:
		animTree.set("parameters/Idle/blend_position", inputDirection)
		animTree.set("parameters/Walk/blend_position", inputDirection)
		animTree.set("parameters/Turn/blend_position", inputDirection)
		change_front_check_position(inputDirection)
		if need_to_turn():
			currentPlayerState = playerStates.TURNING
			animState.travel("Turn")
		else:
			initialPosition = position
			isMoving = true
	else:
		animState.travel("Idle")

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
	var desiredStep: Vector2 = inputDirection * Globals.TILE_SIZE / 2
	rayCast.target_position = desiredStep
	rayCast.force_raycast_update()
	if !rayCast.is_colliding():
		percentMovedToNextTile += walk_speed * delta
		if percentMovedToNextTile >= 1.0:
			position = initialPosition + (Globals.TILE_SIZE * inputDirection)
			percentMovedToNextTile = 0.0
			isMoving = false
		else:
			position = initialPosition + (Globals.TILE_SIZE * inputDirection * percentMovedToNextTile)
	else:
		percentMovedToNextTile = 0.0
		isMoving = false
