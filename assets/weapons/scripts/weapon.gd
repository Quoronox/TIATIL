extends Resource
class_name Weapon

@export var weapon_name: String
@export var damage: float
@export var max_ammo: int
@export var fire_rate: float
@export var is_automatic: bool
@export var projectile_range: float
@export var projectile_speed: float
@export_range(0, 100) var accuracy: int
@export var is_hitscan: bool
@export var weapon_model: PackedScene
@export var projectile_scene: PackedScene
@export var pellet_count: int = 1
@export var spread_angle: float = 0.0
@export var weapon_position: Vector3 = Vector3(0.2, -0.2, -0.3)
