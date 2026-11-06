extends Node
## Global state that survives scene changes: selections and the level timer.

## Emitted every frame while the timer runs, so the HUD can display it.
signal level_time_changed(seconds: float)

const MAIN_MENU_SCENE := "res://scenes/menus/main_menu.tscn"

## All selectable ships. Filled in later when the ship resources exist.
var ships: Array[ShipData] = []
## Scene paths of the playable levels. Filled in later.
var level_scenes: Array[String] = []

var selected_ship_index: int = 0
var selected_level_index: int = 0

## Seconds elapsed in the current level attempt.
var level_time: float = 0.0
var timer_running: bool = false


func _process(delta: float) -> void:
	if timer_running:
		level_time += delta
		level_time_changed.emit(level_time)


## Returns the ship the player picked, or null if none are registered yet.
func get_selected_ship() -> ShipData:
	if ships.is_empty():
		return null
	return ships[selected_ship_index]


## Returns the scene path of the chosen level, or an empty string if none exist yet.
func get_selected_level_path() -> String:
	if level_scenes.is_empty():
		return ""
	return level_scenes[selected_level_index]


func start_level_timer() -> void:
	level_time = 0.0
	timer_running = true


func stop_level_timer() -> void:
	timer_running = false


## Formats seconds as M:SS.s for the completion screen and HUD.
func format_time(seconds: float) -> String:
	var minutes := int(seconds) / 60
	var secs := fmod(seconds, 60.0)
	return "%d:%04.1f" % [minutes, secs]


func go_to_main_menu() -> void:
	stop_level_timer()
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


## Restarts the level the player is currently in (used by Continue and Replay).
func restart_current_level() -> void:
	stop_level_timer()
	get_tree().reload_current_scene()
