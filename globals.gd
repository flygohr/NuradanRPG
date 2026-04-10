extends Node

const TILE_SIZE = 16
const CHUNK_SIZE = 24
var CAMERA_ZOOM := 1 # Default is 4
var PLAYER_SPEED := 7 # Default is 7
var ZONE_DETECTION_AREA_INCREASE := 0 # Extra tiles inbetween zones detection (for preloading and waiting to deload)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fullscreen"):
		var mode := DisplayServer.window_get_mode()
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)

enum ZONE_NAMES { 
	SUND, 
	SUND_FIELDS, 
	CLAIRVOYANT_RISE, 
	SUND_SLOPE, 
	BEARFALL, 
	REDROCK_SPAN,
	WHISPERCREEK_CHASM
}

var ZONE_UIDS: Dictionary[ZONE_NAMES, String] = {
	ZONE_NAMES.SUND: "uid://qhvrd0ywc85l",
	ZONE_NAMES.SUND_FIELDS: "uid://j3rpiiqfmt12",
	ZONE_NAMES.CLAIRVOYANT_RISE: "uid://btha5xug2urfc",
	ZONE_NAMES.SUND_SLOPE: "uid://b6wmwr84e51cr",
	ZONE_NAMES.BEARFALL: "uid://bycigh15ekbdj",
	ZONE_NAMES.REDROCK_SPAN: "uid://b48gq33vn1cad",
	ZONE_NAMES.WHISPERCREEK_CHASM: "uid://ddgvhqavwuuog"
}
