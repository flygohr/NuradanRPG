extends Sprite2D

@onready var _animation_player = $AnimationPlayer
@onready var rayCast = $RayCast2D
@onready var frontCheck = $FrontCheck


enum playerStates { IDLE, TURNING, WALKING }

var currentPlayerState = playerStates.IDLE
var currentFacingDirection : Vector2 = Vector2.DOWN

var inputDirection : Vector2
var isMoving = false
var moveSpeed : float = 0.2

func _ready() -> void: 
	_animation_player.play("idleDown")

func _unhandled_input(event: InputEvent) -> void:
	inputDirection = Vector2.ZERO
	if event.is_action_pressed("ui_left"): inputDirection = Vector2.LEFT
	if event.is_action_pressed("ui_right"): inputDirection = Vector2.RIGHT
	if event.is_action_pressed("ui_up"): inputDirection = Vector2.UP
	if event.is_action_pressed("ui_down"): inputDirection = Vector2.DOWN

	if inputDirection == Vector2.ZERO: return

	if not currentFacingDirection.is_equal_approx(inputDirection):
		updateFacingDirection()
	else:
		move()

func move():
	if inputDirection:
		if isMoving == false and !rayCast.is_colliding():
			isMoving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position+inputDirection*Globals.TILE_SIZE, moveSpeed)
			
			# animate walk here
			
			tween.tween_callback(stopMoving)
			
func stopMoving():
	isMoving = false
	updateFacingDirection()

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
