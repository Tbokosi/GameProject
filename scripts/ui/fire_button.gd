class_name TouchFireButton
extends Control
## On-screen fire button. Reports whether a finger is currently holding it.

## Emitted when the button is pressed (true) or released (false).
signal fire_state_changed(is_firing: bool)

## Radius of the button circle, in pixels.
@export var button_radius: float = 90.0
@export var idle_color := Color(1, 0.3, 0.3, 0.35)
@export var pressed_color := Color(1, 0.3, 0.3, 0.75)

var is_pressed: bool = false

var _touch_index: int = -1


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1 and _is_inside(event.position):
			_touch_index = event.index
			_set_pressed(true)
		elif not event.pressed and event.index == _touch_index:
			_touch_index = -1
			_set_pressed(false)


func _is_inside(screen_position: Vector2) -> bool:
	var centre := global_position + size / 2.0
	return screen_position.distance_to(centre) <= button_radius


func _set_pressed(value: bool) -> void:
	is_pressed = value
	fire_state_changed.emit(is_pressed)
	queue_redraw()


func _draw() -> void:
	var centre := size / 2.0
	var colour := pressed_color if is_pressed else idle_color
	draw_circle(centre, button_radius, colour)
	draw_arc(centre, button_radius, 0.0, TAU, 48, Color(1, 1, 1, 0.5), 3.0)
