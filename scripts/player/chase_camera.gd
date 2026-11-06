class_name ChaseCamera
extends Camera3D
## Third-person chase camera: follows behind the ship with smooth lag,
## looks slightly ahead of the nose, and widens the FOV with speed.

## Ship to follow. If empty, the parent node is used.
@export var target: PlayerShip
## Camera position relative to the ship, in the ship's own axes.
@export var offset := Vector3(0.0, 3.0, 9.0)
## Higher values keep the camera tighter to the ship.
@export var position_smoothing: float = 8.0
## How far in front of the ship the camera looks, in units.
@export var look_ahead: float = 25.0
## Field of view at standstill, in degrees.
@export var base_fov: float = 70.0
## Extra degrees of FOV added at max speed.
@export var max_fov_boost: float = 15.0
@export var fov_smoothing: float = 3.0


func _ready() -> void:
	# Ignore the parent's transform so we can follow with our own smoothing.
	top_level = true
	if target == null:
		target = get_parent() as PlayerShip
	if target != null:
		global_position = _get_desired_position()
		_look_ahead_of_target()


func _physics_process(delta: float) -> void:
	if target == null:
		return
	var follow_weight := 1.0 - exp(-position_smoothing * delta)
	global_position = global_position.lerp(_get_desired_position(), follow_weight)
	_look_ahead_of_target()
	_update_fov(delta)


func _get_desired_position() -> Vector3:
	return target.global_position + target.global_transform.basis * offset


func _look_ahead_of_target() -> void:
	var ship_basis := target.global_transform.basis
	var focus := target.global_position - ship_basis.z * look_ahead
	look_at(focus, ship_basis.y)


func _update_fov(delta: float) -> void:
	var speed_fraction := 0.0
	if target.ship_data != null and target.ship_data.max_speed > 0.0:
		speed_fraction = clampf(target.current_speed / target.ship_data.max_speed, 0.0, 1.0)
	var goal_fov := base_fov + max_fov_boost * speed_fraction
	fov = lerpf(fov, goal_fov, 1.0 - exp(-fov_smoothing * delta))
