extends Sprite2D

@onready var rayCast := $RayCast2D
@onready var frontCheck := $FrontCheck
@onready var anim_tree := $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

enum playerStates { IDLE, TURNING, WALKING }
const MOVEMENTS = {
	'ui_up': Vector2.UP,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT,
	'ui_down': Vector2.DOWN,
}
var direction_history := [] # used to store latest inputs

var currentPlayerState := playerStates.IDLE
var currentFacingDirection := Vector2.DOWN

var inputDirection : Vector2
var isMoving := false
@export var moveSpeed := 0.2

func _ready() -> void: 
	anim_state.travel("Idle")


func _physics_process(_delta: float) -> void:

	updateFacingDirection()
	processInput()

func processInput():
	# tap to turn
	# tap to move once
	# keep holding to keep moving
	
	inputDirection = Vector2.ZERO
	anim_tree.set("parameters/Idle/blend_position", currentFacingDirection)
	anim_tree.set("parameters/Walk/blend_position", currentFacingDirection)
	anim_tree.set("parameters/Turn/blend_position", currentFacingDirection)
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
	
	if inputDirection:
		rayCast.force_raycast_update()
		if isMoving == false and !rayCast.is_colliding():
			isMoving = true
			anim_state.travel("Walk")
			var tween = create_tween()
			tween.tween_property(self, "position", position+inputDirection*Globals.TILE_SIZE, moveSpeed)
			tween.tween_callback(stopMoving)
			
func stopMoving():
	isMoving = false
	anim_state.travel("Idle")

func updateFacingDirection():
	match inputDirection:
		Vector2.UP:
			currentFacingDirection = inputDirection
			rayCast.target_position.x = 0
			rayCast.target_position.y = -Globals.TILE_SIZE
			frontCheck.position.x = 0
			frontCheck.position.y = -(Globals.TILE_SIZE*2)
		Vector2.RIGHT:
			currentFacingDirection = inputDirection
			rayCast.target_position.x = Globals.TILE_SIZE
			rayCast.target_position.y = 0
			frontCheck.position.x = Globals.TILE_SIZE
			frontCheck.position.y = -Globals.TILE_SIZE
		Vector2.DOWN:
			currentFacingDirection = inputDirection
			rayCast.target_position.x = 0
			rayCast.target_position.y = Globals.TILE_SIZE
			frontCheck.position.x = 0
			frontCheck.position.y = 0
		Vector2.LEFT:
			currentFacingDirection = inputDirection
			rayCast.target_position.x = -Globals.TILE_SIZE
			rayCast.target_position.y =  0
			frontCheck.position.x = -Globals.TILE_SIZE
			frontCheck.position.y = -Globals.TILE_SIZE
