class_name LaserBolt
extends Area3D
## Fast projectile that flies forward (-Z), damages the first thing it hits, then vanishes.

## Travel speed in units per second.
@export var speed: float = 150.0
## Damage dealt to a HealthComponent on impact.
@export var damage: int = 10
## Seconds before the bolt disappears if it hits nothing.
@export var lifetime: float = 2.5

var _age: float = 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	global_position += -global_transform.basis.z * speed * delta
	_age += delta
	if _age >= lifetime:
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	var health := body.get_node_or_null("HealthComponent") as HealthComponent
	if health != null:
		health.take_damage(damage)
	queue_free()
