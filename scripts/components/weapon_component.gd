class_name WeaponComponent
extends Node
## Fires laser bolts from a set of muzzle markers at a limited rate.

## The projectile scene to spawn.
@export var laser_scene: PackedScene
## Parent node whose Marker3D children are the muzzles.
@export var muzzles_root: Node3D
## Shots per second.
@export var fire_rate: float = 6.0
## Damage each bolt deals.
@export var damage: int = 10

## Set true while the trigger is held; the weapon fires on its own timing.
var is_firing: bool = false

var _cooldown: float = 0.0
var _next_muzzle: int = 0
var _muzzles: Array[Marker3D] = []


func _ready() -> void:
	if muzzles_root == null:
		return
	for child in muzzles_root.get_children():
		if child is Marker3D:
			_muzzles.append(child)


func _physics_process(delta: float) -> void:
	_cooldown -= delta
	if is_firing and _cooldown <= 0.0:
		_fire()


## Spawns one bolt at the next muzzle, alternating between them.
func _fire() -> void:
	if laser_scene == null or _muzzles.is_empty():
		return
	_cooldown = 1.0 / fire_rate
	var muzzle := _muzzles[_next_muzzle]
	_next_muzzle = (_next_muzzle + 1) % _muzzles.size()
	var bolt := laser_scene.instantiate() as LaserBolt
	bolt.damage = damage
	get_tree().current_scene.add_child(bolt)
	bolt.global_transform = muzzle.global_transform
