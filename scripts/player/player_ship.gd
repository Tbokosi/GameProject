class_name PlayerShip
extends CharacterBody3D
## Player-controlled ship: constant forward thrust, steered by a 2D input vector.

## Emitted when the ship's health reaches zero.
signal destroyed

## Stats for this ship. If empty, the ship picked in GameState is used.
@export var ship_data: ShipData
## How far the model banks (rolls) when turning, in radians.
@export var max_bank_angle: float = 0.6
## How quickly the model banks toward its target angle.
@export var bank_smoothing: float = 6.0
## Fraction of speed kept after hitting an obstacle.
@export_range(0.0, 1.0) var collision_speed_retention: float = 0.3

## Steering input from -1 to 1 on each axis. The joystick will write to this.
var steer_input: Vector2 = Vector2.ZERO
var current_speed: float = 0.0
## Set true by the fire button while it is held.
var fire_input: bool = false

@onready var _model_holder: Node3D = $ModelHolder
@onready var _health: HealthComponent = $HealthComponent
@onready var weapon: WeaponComponent = $Weapon


func _ready() -> void:
	motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	if ship_data == null:
		ship_data = GameState.get_selected_ship()
	if ship_data == null:
		push_warning("PlayerShip has no ShipData assigned.")
		return
	_apply_ship_data()
	_health.died.connect(_on_died)


func _physics_process(delta: float) -> void:
	if ship_data == null or _health.is_dead:
		return
	weapon.is_firing = fire_input or Input.is_action_pressed("ui_accept")
	var input := _get_steer_input()
	_rotate_ship(input, delta)
	_update_bank(input, delta)
	_move_forward(delta)


## Applies the stats and model from the ShipData resource.
func _apply_ship_data() -> void:
	_health.setup(ship_data.max_health)
	if ship_data.model_scene != null:
		_model_holder.add_child(ship_data.model_scene.instantiate())


## Returns the joystick value, or arrow keys as a temporary PC test fallback.
func _get_steer_input() -> Vector2:
	if steer_input != Vector2.ZERO:
		return steer_input
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


## Yaw (left/right) and pitch (up/down) around the ship's own axes.
func _rotate_ship(input: Vector2, delta: float) -> void:
	rotate_object_local(Vector3.UP, -input.x * ship_data.turn_speed * delta)
	rotate_object_local(Vector3.RIGHT, -input.y * ship_data.turn_speed * delta)


## Rolls only the visual model, so turning feels natural without changing the path.
func _update_bank(input: Vector2, delta: float) -> void:
	var target_roll := -input.x * max_bank_angle
	_model_holder.rotation.z = lerp(
		_model_holder.rotation.z, target_roll, bank_smoothing * delta
	)


func _move_forward(delta: float) -> void:
	current_speed = move_toward(
		current_speed, ship_data.max_speed, ship_data.acceleration * delta
	)
	velocity = -global_transform.basis.z * current_speed
	move_and_slide()
	if get_slide_collision_count() > 0:
		current_speed *= collision_speed_retention


func _on_died() -> void:
	destroyed.emit()
