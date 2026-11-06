class_name EnemyData
extends Resource
## Stats for one enemy type.

@export var display_name: String = "Enemy"
@export var model_scene: PackedScene
@export var max_speed: float = 25.0
@export var acceleration: float = 15.0
@export var turn_speed: float = 1.5
@export var max_health: int = 40
## Player closer than this triggers the Chase state.
@export var chase_range: float = 120.0
## Player closer than this triggers the Attack state.
@export var attack_range: float = 60.0
@export var fire_rate: float = 1.5
@export var damage: int = 8
