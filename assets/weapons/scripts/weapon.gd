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

@export_group("Recoil")
@export var recoil_cam_pitch: float = 1.0
@export var recoil_cam_yaw: float = 0.25
@export var recoil_cam_roll: float = 0.0
@export var recoil_model_kickback: float = 0.02
@export var recoil_model_rise: float = 8.0

@export_group("Muzzle Flash")
@export var muzzle_flash_enable: bool = true
@export var muzzle_process_material: ParticleProcessMaterial
@export var muzzle_flash_mesh: Mesh
@export var muzzle_light_color: Color = Color(1.0, 0.8, 0.4)
@export var muzzle_ligt_energy: float = 10.0
@export var muzzle_ligt_durration: float = 0.05
@export var muzzle_flash_scale: float = 0.2
