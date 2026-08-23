# Following this tutorial: https://youtu.be/m4PfHg3hmSo?is=u45-mfP6rygY3gi6
extends Node

signal progress_changed(progress)
signal load_finished

const KEY_TITLE_SCREEN: String = "title screen"
const KEY_LOADING_SCREEN: String = "loading screen"
const KEY_GAME_SCREEN: String = "game screen"
const KEY_SETTINGS_SCREEN: String = "settings screen"

const SCENE_PATHS: Dictionary = {
	KEY_TITLE_SCREEN: "uid://q3362xrshrsu",
	KEY_LOADING_SCREEN: "uid://bbn1nvys51vyr",
	KEY_GAME_SCREEN: "uid://rnr1t4ufnvnh",
	KEY_SETTINGS_SCREEN: "uid://cc1yqy62xbprh"
}

const LOADING_SCREEN: PackedScene = preload(SCENE_PATHS[KEY_LOADING_SCREEN])

var loaded_resource: PackedScene
var scene_path: String
var progress: Array = []
var use_sub_threads: bool = true

func _ready() -> void:
	set_process(false)
	
func load_scene(_scene_path: String) -> void:
	scene_path = _scene_path
	
	var new_load_screen = LOADING_SCREEN.instantiate()
	add_child(new_load_screen)
	progress_changed.connect(new_load_screen._on_progress_changed)
	load_finished.connect(new_load_screen._on_load_finished)
	
	await new_load_screen.loading_screen_ready
	
	start_load()
	
func start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	if state == OK:
		set_process(true)
		
func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	progress_changed.emit(progress[0])
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			get_tree().change_scene_to_packed(loaded_resource)
			load_finished.emit()
