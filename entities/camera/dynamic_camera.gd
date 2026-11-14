extends Camera3D
class_name DynamicCamera

@export var trauma_reduction_rate := 1.0
@export var noise: FastNoiseLite
@export var noise_speed := 50.0

@export_category("max shift amount")
@export var max_x: float = 10.0
@export var max_y: float = 10.0
@export var max_z: float = 5.0

@export_category("Weapon Kick")
@export var recoil_cam_stiffness: float = 80.0
@export var recoil_cam_damping: float = 10.0
@export var recoil_cam_max: float = 50.0
@export var enable_weapon_kick: bool = true

var trauma := 0.0
var time := 0.0


@onready var camera = $"."
@onready var initial_rotation := camera.rotation_degrees as Vector3


# Weapon Recoil
var _recoil_angles: Vector3 = Vector3.ZERO
var _recoil_velocity: Vector3 = Vector3.ZERO


func _process(delta) -> void:
	calculate_view_offset(delta)
	
	#time += delta
	#trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
#
	#camera.rotation_degrees.x = initial_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0)
	#camera.rotation_degrees.y = initial_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1)
	#camera.rotation_degrees.z = initial_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2)
	
	

func add_trauma(trauma_amount: float) -> void:
	#print("activated Add_trauma")
	trauma = clamp(trauma + trauma_amount, 0.0, 1.0)

func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(_seed: int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)


func calculate_view_offset(delta: float) -> void:
	
	var angles = Vector3.ZERO
	var offset = Vector3.ZERO
	
	# screen shake
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)

	angles.x += deg_to_rad(initial_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0))
	angles.y += deg_to_rad(initial_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1))
	angles.z += deg_to_rad(initial_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2))
	
	
	# weapon kick
	if enable_weapon_kick:
		var d = min(delta, 0.05)
		var angle_max = deg_to_rad(recoil_cam_max)
		
		for axis in 3:
			var r = SpringUtility.apply(_recoil_angles[axis], _recoil_velocity[axis], 0.0, recoil_cam_stiffness, recoil_cam_damping, d)
			_recoil_angles[axis] = clamp(r.x, -angle_max, angle_max)
			_recoil_velocity[axis] = r.y
		angles += _recoil_angles
	
	
	self.rotation = angles
	self.position = offset


func add_weapon_kick(pitch: float, yaw: float, roll: float) -> void:
	_recoil_angles.x += deg_to_rad(pitch)
	_recoil_angles.y += deg_to_rad(randf_range(-yaw, yaw))
	_recoil_angles.z += deg_to_rad(randf_range(-roll, roll))
	
	
