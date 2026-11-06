class_name TouchJoystick
extends Control
## On-screen touch joystick. Tracks one finger and emits a steering vector.

## Emitted whenever the stick value changes. Each axis is from -1 to 1.
signal direction_changed(direction: Vector2)

## Distance the knob can travel from the centre, in pixels.
@export var base_radius: float = 130.0
## Radius of the draggable knob, in pixels.
@export var knob_radius: float = 55.0
## Stick values smaller than this are treated as zero.
@export_range(0.0, 0.5) var dead_zone: float = 0.1
@export var base_color := Color(1, 1, 1, 0.15)
@export var knob_color := Color(1, 1, 1, 0.5)

var direction: Vector2 = Vector2.ZERO

var _touch_index: int = -1
var _knob_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	# Let touches pass through; we read raw touch events in _input().
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1 \
				and get_global_rect().has_point(event.position):
			_touch_index = event.index
			_update_stick(event.position)
		elif not event.pressed and event.index == _touch_index:
			_release()
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update_stick(event.position)


func _update_stick(screen_position: Vector2) -> void:
	var centre := global_position + size / 2.0
	_knob_offset = (screen_position - centre).limit_length(base_radius)
	var raw := _knob_offset / base_radius
	direction = raw if raw.length() > dead_zone else Vector2.ZERO
	direction_changed.emit(direction)
	queue_redraw()


func _release() -> void:
	_touch_index = -1
	_knob_offset = Vector2.ZERO
	direction = Vector2.ZERO
	direction_changed.emit(direction)
	queue_redraw()


func _draw() -> void:
	var centre := size / 2.0
	draw_circle(centre, base_radius, base_color)
	draw_arc(centre, base_radius, 0.0, TAU, 48, Color(1, 1, 1, 0.4), 3.0)
	draw_circle(centre + _knob_offset, knob_radius, knob_color)
