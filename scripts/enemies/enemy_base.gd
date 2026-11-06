class_name Enemy
extends CharacterBody3D
## Base enemy: stats from EnemyData, health, weapon and death.
## Movement and decisions are added by the state machine later.

## Emitted when this enemy is destroyed.
signal destroyed(enemy: Enemy)

@export var data: EnemyData

## The player ship this enemy hunts. Found automatically.
var target: Node3D
var current_speed: float = 0.0

@onready var health: HealthComponent = $HealthComponent
@onready var weapon: WeaponComponent = $Weapon
@onready var _model_holder: Node3D = $ModelHolder


func _ready() -> void:
	motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	add_to_group("enemies")
	target = get_tree().get_first_node_in_group("player") as Node3D
	if data == null:
		push_warning("Enemy has no EnemyData assigned.")
		return
	health.setup(data.max_health)
	weapon.fire_rate = data.fire_rate
	weapon.damage = data.damage
	if data.model_scene != null:
		_model_holder.add_child(data.model_scene.instantiate())
	health.died.connect(_on_died)


func _on_died() -> void:
	destroyed.emit(self)
	queue_free()
