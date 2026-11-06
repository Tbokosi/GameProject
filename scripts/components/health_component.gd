class_name HealthComponent
extends Node
## Tracks hit points for any entity (player or enemy) and reports changes.

## Emitted whenever health changes, so the HUD can update its bar.
signal health_changed(current: int, maximum: int)
## Emitted when damage is taken, with the amount (useful for hit effects).
signal damaged(amount: int)
## Emitted once when health reaches zero.
signal died

## Maximum hit points. Call setup() to change it at runtime.
@export var max_health: int = 100

var current_health: int = 100
var is_dead: bool = false


func _ready() -> void:
	current_health = max_health


## Sets a new maximum and refills health. Used when stats come from ShipData
## or EnemyData at spawn time.
func setup(new_max_health: int) -> void:
	max_health = new_max_health
	reset()


## Restores full health and clears the dead flag.
func reset() -> void:
	current_health = max_health
	is_dead = false
	health_changed.emit(current_health, max_health)


## Reduces health by amount. Does nothing if already dead.
func take_damage(amount: int) -> void:
	if is_dead or amount <= 0:
		return
	current_health = maxi(current_health - amount, 0)
	damaged.emit(amount)
	health_changed.emit(current_health, max_health)
	if current_health == 0:
		is_dead = true
		died.emit()


## Adds health, capped at the maximum. Does nothing if dead.
func heal(amount: int) -> void:
	if is_dead or amount <= 0:
		return
	current_health = mini(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)


## Health as a 0.0 to 1.0 value, handy for progress bars.
func get_health_fraction() -> float:
	if max_health <= 0:
		return 0.0
	return float(current_health) / float(max_health)
