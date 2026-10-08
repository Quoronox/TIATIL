extends Resource
class_name Weapon

@export var weapon_name: String
@export var damage: float
@export var max_ammo: int
@export var projectile_range: float
@export var is_hitscan: bool
@export var weapon_model: PackedScene
@export var projectile_scene: PackedScene
@export var weapon_position: Vector3 = Vector3(0.2, -0.2, -0.3)
