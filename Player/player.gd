extends Sprite2D

@onready var _animation_player = $AnimationPlayer
@onready var rayCast = $RayCast2D
@onready var frontCheck = $FrontCheck


enum playerStates { IDLE, TURNING, WALKING }
enum facingDirections { LEFT, RIGHT, UP, DOWN }

var currentPlayerState = playerStates.IDLE
var currentFacingDirection = facingDirections.DOWN

var inputDirection
var isMoving = false
var moveSpeed : float = 0.2


var holdCounter : float = 0.0
var holdTime : float = 0.3

func _physics_process(delta): # delta = reliable way to keep track of time regardless of frames
	inputDirection = Vector2.ZERO

	if Input.is_action_just_released("ui_up"):
		holdCounter = 0.0
		
	elif Input.is_action_pressed("ui_up"):
		print(holdCounter)
		holdCounter += delta
		_animation_player.play("idleUp")
		inputDirection = Vector2.UP
		if holdCounter >= holdTime and !rayCast.is_colliding():
			move()
		elif holdCounter < holdTime: # work on this damn thing here
			if currentFacingDirection != facingDirections.UP:
				print("turning")
				Globals.wait(holdTime)
				updateFacingDirection()
			elif currentFacingDirection == facingDirections.UP and !rayCast.is_colliding():
				print("moving")
				move()
		
	elif Input.is_action_pressed("ui_right"):
		inputDirection = Vector2.RIGHT
		_animation_player.play("idleRight")
		if currentFacingDirection == facingDirections.RIGHT and !rayCast.is_colliding():
			move()
		updateFacingDirection()
		
	elif Input.is_action_pressed("ui_down"):
		inputDirection = Vector2.DOWN
		_animation_player.play("idleDown")
		if currentFacingDirection == facingDirections.DOWN and !rayCast.is_colliding():
			move()
		updateFacingDirection()
		
	elif Input.is_action_pressed("ui_left"):
		inputDirection = Vector2.LEFT
		_animation_player.play("idleLeft")
		if currentFacingDirection == facingDirections.LEFT and !rayCast.is_colliding():
			move()
		updateFacingDirection()

func move():
	if inputDirection:
		if isMoving == false:
			isMoving = true
			updateFacingDirection()
			var tween = create_tween()
			tween.tween_property(self, "position", position+inputDirection*Globals.TILE_SIZE, moveSpeed)
			tween.tween_callback(stopMoving)
			
func stopMoving():
	isMoving = false

func updateFacingDirection():
	if inputDirection == Vector2.UP:
		currentFacingDirection = facingDirections.UP
		rayCast.target_position.x = 0
		rayCast.target_position.y = -Globals.TILE_SIZE
		frontCheck.position.x = 0
		frontCheck.position.y = -(Globals.TILE_SIZE*2)
	elif inputDirection == Vector2.RIGHT:
		currentFacingDirection = facingDirections.RIGHT
		rayCast.target_position.x = Globals.TILE_SIZE
		rayCast.target_position.y = 0
		frontCheck.position.x = Globals.TILE_SIZE
		frontCheck.position.y = -Globals.TILE_SIZE
	elif inputDirection == Vector2.DOWN:
		currentFacingDirection = facingDirections.DOWN
		rayCast.target_position.x = 0
		rayCast.target_position.y = Globals.TILE_SIZE
		frontCheck.position.x = 0
		frontCheck.position.y = 0
	elif inputDirection == Vector2.LEFT:
		currentFacingDirection = facingDirections.LEFT
		rayCast.target_position.x = -Globals.TILE_SIZE
		rayCast.target_position.y =  0
		frontCheck.position.x = -Globals.TILE_SIZE
		frontCheck.position.y = -Globals.TILE_SIZE
