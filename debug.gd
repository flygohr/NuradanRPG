extends CanvasLayer

var IS_DEBUG = false # Enable or disable debug mode

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rich_text_label.text = str(
		"FPS: ", int(Engine.get_frames_per_second()),
		"\nMemory: ", OS.get_static_memory_usage()/1024/1024, "MiB"
	)

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("Debug"):
		if IS_DEBUG == true: 
			IS_DEBUG = false
			set_process(false)
			hide()
		else: 
			IS_DEBUG = true
			set_process(true)
			show()
		
	if event.is_action_pressed("Zoom in") and IS_DEBUG:
		Globals.CAMERA_ZOOM = 1.0
	
	if event.is_action_pressed("Zoom out") and IS_DEBUG:
		Globals.CAMERA_ZOOM = 0.1
