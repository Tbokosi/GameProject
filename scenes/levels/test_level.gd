extends Node3D
## Temporary test script: wires the joystick to the ship. Deleted later.

@onready var _ship: PlayerShip = $PlayerShip
@onready var _joystick: TouchJoystick = $CanvasLayer/VirtualJoystick
@onready var _fire_button: TouchFireButton = $CanvasLayer/FireButton


func _ready() -> void:
	_joystick.direction_changed.connect(_on_direction_changed)
	_fire_button.fire_state_changed.connect(_on_fire_state_changed)


func _on_direction_changed(direction: Vector2) -> void:
	_ship.steer_input = direction
	


func _on_fire_state_changed(is_firing: bool) -> void:
	_ship.fire_input = is_firing
