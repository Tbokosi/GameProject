class_name ShipData
extends Resource
## Stats and scene reference for one selectable player ship.

## Name shown on the ship select screen.
@export var display_name: String = "Ship"
## Scene containing the ship's 3D model (assigned later).
@export var model_scene: PackedScene
## Preview image for the ship select screen (assigned later).
@export var icon: Texture2D
## Highest speed the ship can reach, in units per second.
@export var max_speed: float = 40.0
## How quickly the ship reaches its max speed, in units per second squared.
@export var acceleration: float = 20.0
## How fast the ship can rotate, in radians per second.
@export var turn_speed: float = 2.0
## Hit points before the ship is destroyed.
@export var max_health: int = 100
