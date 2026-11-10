extends Node
class_name WeaponController

@export var debug_mode: bool = false
@export var debug_mode_projectile_hits: bool = false

@export var player: Player

@export var camera: Camera3D
@export var weapon_model_parent: Node3D

# ---------- manual access to idle state -----------
@export var weapon_idle_state : WeaponBaseState
# --------------------------------------------------

@export_group("Visual Enhancers")
@export var do_idle_sway: bool = true
@export var do_look_sway: bool = true

@export_group("Idle Sway")
@export var idle_sway_frequency: float = 0.8
@export var idle_sway_amplitude: Vector2 = Vector2(0.01, 0.01)
@export var idle_sway_stiffness: float = 40.0
@export var idle_sway_damping: float = 4.0

@export_group("Look Sway")
@export var look_lag_divisor: float = 10.0
@export var look_lag_rotation_max: float = 30.0
@export var look_lag_position_scale: float = 0.2

@export_group("Strafe Tilt")
@export var strafe_tilt_scale: float = 0.3
@export var strafe_tilt_max: float = 0.08
@export var strafe_tilt_stiffness: float = 60.0
@export var strafe_tilt_damping: float = 5.0

var current_weapon: Weapon

var current_weapon_model: Node3D
#var current_ammo: int

var can_fire_next: bool = true
var fire_rate_timer: float = 0.0


var base_weapon_position: Vector3
var base_weapon_rotation: Vector3

# Idle sway
var idle_time: float = 0.0
var _idle_x: float = 0.0
var _idle_y: float = 0.0
var _idle_x_vel: float = 0.0
var _idle_y_vel: float = 0.0

# Look sway
var _prev_camera_rotation: Vector3 = Vector3.ZERO
var _camera_rotation_rate: Vector3 = Vector3.ZERO

# Strafe Tilt
var _strafe_tilt: float = 0.0
var _strafe_tilt_vel: float = 0.0


func _ready() -> void:
	
	#SceneManager.load_complete.connect(_on_world_loaded)
	
	if current_weapon:
		spawn_weapon_model()
		#current_ammo = current_weapon.max_ammo


func _process(delta: float) -> void:
	if not SceneManager._loading_in_progress:
		
		if fire_rate_timer > 0:
			fire_rate_timer -= delta
			if fire_rate_timer <= 0:
				can_fire_next = true
		
		apply_offsets(delta)


func spawn_weapon_model() -> void:
	if current_weapon_model:
		current_weapon_model.queue_free()
		if debug_mode: DevConsole._push_warning("WC - removed duplicate current_weapon_model")
	
	if current_weapon.weapon_model:
		if debug_mode: DevConsole._push_info("WC - added current_weapon_model")
		current_weapon_model = current_weapon.weapon_model.instantiate()
		weapon_model_parent.add_child(current_weapon_model)
		current_weapon_model.position = current_weapon.weapon_position
		
		# Store base pos/rot for offset calculations
		base_weapon_position = current_weapon.weapon_position
		base_weapon_rotation = Vector3.ZERO


func can_fire() -> bool:
	var weapon_manager = get_tree().get_first_node_in_group("weapon_manager") as WeaponManager
	var weapon_data = weapon_manager.weapons[weapon_manager.current_slot]
	return (weapon_data.ammo > 0) and can_fire_next


func fire_weapon() -> void:
	var weapon_manager = get_tree().get_first_node_in_group("weapon_manager") as WeaponManager
	
	if can_fire():
		weapon_manager.use_ammo(weapon_manager.current_slot)
		#current_ammo = weapon_manager.get_current_ammo()
		if debug_mode: DevConsole._push_complete("WC - Fired, Ammo: " + str(weapon_manager.get_current_ammo()))
		
		# start fire rate cooldown
		can_fire_next = false
		fire_rate_timer = 1.0 / current_weapon.fire_rate
		
		if current_weapon.is_hitscan:
			_perform_hitscan()
		else:
			_spawn_projectile()


func _perform_hitscan() -> void:
	if not camera:
		if debug_mode: DevConsole._push_error("WC - ERROR: no camera assigned")
		return
	
	var space_state = camera.get_world_3d().direct_space_state
	var camera_origin = camera.global_position
	
	# calculate accuracy spread (inverse relationship)
	var accuracy_spread = (100 - current_weapon.accuracy) / 1000.0
	
	for i in current_weapon.pellet_count: # for loop : fire multiple pellets
		var camera_forward = -camera.global_transform.basis.z
		
		
		# add accuracy randomness
		var accuracy_x = randf_range(-accuracy_spread, accuracy_spread)
		var accuracy_y = randf_range(-accuracy_spread, accuracy_spread)
		var direction = camera_forward + Vector3(accuracy_x , accuracy_y, 0) * camera.global_transform.basis
		
		# add pellet spread if multiple pellets
		if current_weapon.pellet_count > 1:
			var spread_x = randf_range(-current_weapon.spread_angle, current_weapon.spread_angle)
			var spread_y = randf_range(-current_weapon.spread_angle, current_weapon.spread_angle)
			direction += Vector3(spread_x, spread_y, 0) * camera.global_transform.basis
		
		DevConsole._push_text(str(direction))
		var end_direction = camera_origin + direction * current_weapon.projectile_range
		
		
		
		# use query-collision_mask to select specific collision objects...
		var query = PhysicsRayQueryParameters3D.create(camera_origin, end_direction)
		var hitscan_result = space_state.intersect_ray(query)
		
		if hitscan_result:
			if debug_mode_projectile_hits: DevConsole._push_info("Hit: " + str(hitscan_result.collider.name) + " at " + str(hitscan_result.position))
			_spawn_impact_marker(hitscan_result.position)


func _spawn_impact_marker(position: Vector3) -> void:
	var marker = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(0.1, 0.1, 0.1)
	marker.mesh = box_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	marker.set_surface_override_material(0, material)
	
	get_tree().current_scene.add_child(marker)
	marker.global_position = position
	
	get_tree().create_timer(2.0).timeout.connect(marker.queue_free)
	

func _spawn_projectile() -> void:
	if not current_weapon.projectile_scene:
		if debug_mode: DevConsole._push_error("WC - no projectile scene assigned")
		return
	
	if not camera:
		if debug_mode: DevConsole._push_error("WC - ERROR: no camera assigned")
		return
	
	# spawn projectile
	var projectile = current_weapon.projectile_scene.instantiate() as Projectile
	get_tree().current_scene.add_child(projectile)
	
	# position at camera
	projectile.global_position = camera.global_position
	
	# calculate accuracy spread
	var accuracy_spread = (100 - current_weapon.accuracy) / 1000.0

	
	# calculate direction & velocity
	var forward_direction = -camera.global_transform.basis.z
	
	# add accuracy randomness to direction
	var accuracy_x = randf_range(-accuracy_spread, accuracy_spread)
	var accuracy_y = randf_range(-accuracy_spread, accuracy_spread)
	var direction = forward_direction + Vector3(accuracy_x , accuracy_y, 0) * camera.global_transform.basis
	
	var velocity = direction * current_weapon.projectile_speed
	projectile.look_at(projectile.global_position + direction, Vector3.UP)
	
	# setup projectile
	projectile.setup(velocity, current_weapon.damage)


func switch_weapon(weapon_data: WeaponData) -> void:
	current_weapon = weapon_data.weapon
	
	if current_weapon_model:
		current_weapon_model.queue_free()
	
	spawn_weapon_model()
	
	# switch back to idle (avoid getting stuck in empty_state)
	player.wsm.change_state(weapon_idle_state)
	
	if debug_mode: DevConsole._push_text("WC - Enable Weapon" + str(current_weapon.weapon_name))


func has_ammo() -> bool:
	var weapon_manager = get_tree().get_first_node_in_group("weapon_manager") as WeaponManager
	var weapon_data = weapon_manager.weapons[weapon_manager.current_slot]
	return (weapon_data.ammo > 0)


func _update_idle_sway(delta: float) -> Vector3:
	if not current_weapon_model:
		if debug_mode: DevConsole._push_error("WC - ERROR: no current_weapon_model assigned")
		return Vector3.ZERO
	
	# increment time
	idle_time += delta
	
	
	# only drive targets when standing still
	var speed = Vector2(player.velocity.x, player.velocity.z).length()
	var target_x := 0.0
	var target_y := 0.0
	
	if speed < 0.1:
		# calculate sine wave target (figure-8 pattern)
		target_x = sin(idle_time * idle_sway_frequency) * idle_sway_amplitude.x
		target_y = sin(idle_time * idle_sway_frequency * 0.618) * idle_sway_amplitude.y
		
	# Apply spring to X axis
	var result_x = SpringUtility.apply(_idle_x, _idle_x_vel, target_x, idle_sway_stiffness, idle_sway_damping, delta)
	_idle_x = result_x.x
	_idle_x_vel = result_x.y
	
	
	# Apply spring to Y axis
	var result_y = SpringUtility.apply(_idle_y, _idle_y_vel, target_y, idle_sway_stiffness, idle_sway_damping, delta)
	_idle_y = result_y.x
	_idle_y_vel = result_y.y
	
	
	# Apply offset to weapon
	var idle_offset = Vector3(_idle_x, _idle_y, 0.0)
	
	
	
	return idle_offset
	
	
func _update_look_sway(delta: float) -> Vector3:
	if not camera:
		if debug_mode: DevConsole._push_error("WC - ERROR: no camera assigned")
		return Vector3.ZERO
	
	# Get current camera rotation
	var camera_rotation = camera.global_rotation
	
	# Calculate rotation delta (how much camera rotated this frame)
	var rotation_delta = camera_rotation - _prev_camera_rotation
	_prev_camera_rotation = camera_rotation
	
	# Clamp rotation delta to max tracking mount
	var max_rad = deg_to_rad(look_lag_rotation_max)
	rotation_delta.x = clamp(rotation_delta.x, -max_rad, max_rad)
	rotation_delta.y = clamp(rotation_delta.y, -max_rad, max_rad)
	rotation_delta.z = 0.0 # Ignore
	
	# smooth the rotation rate (frame rate independent)
	var interp_speed = (1.0 / delta) / look_lag_divisor
	_camera_rotation_rate = _camera_rotation_rate.lerp(rotation_delta, clamp(interp_speed * delta, 0.0, 1.0))
	
	# Derive position offset from rotation rate
	var normal_pitch = _camera_rotation_rate.x / max_rad if max_rad > 0.0 else 0.0
	var normal_yaw = _camera_rotation_rate.y / max_rad if max_rad > 0.0 else 0.0
	var look_position = Vector3(normal_yaw * look_lag_position_scale, normal_pitch * -look_lag_position_scale, 0.0)
	
	
	return look_position


func _update_strafe_tilt(delta: float) -> float:
	if not player or not camera:
		if debug_mode: DevConsole._push_error("WC - ERROR: no camera and no player assigned")
		return 0.0
	
	# Convert camera velocity to camera-local space
	var local_velocity = camera.global_transform.basis.inverse() * player.velocity
	
	# Get horizontal movement (x and z in local space)
	var xz = Vector2(local_velocity.x, local_velocity.z)
	var xz_speed = xz.length()
	
	# Calculate lateral fraction
	var lateral_fraction = abs(xz.x) / xz_speed if xz_speed > 0.1 else 0.0
	
	# Calculate tilt target
	var tilt_target = clamp(-local_velocity.x * lateral_fraction * strafe_tilt_scale, -strafe_tilt_max, strafe_tilt_max)
	
	# Apply spring
	var result = SpringUtility.apply(_strafe_tilt, _strafe_tilt_vel, tilt_target, strafe_tilt_stiffness, strafe_tilt_damping, delta)
	_strafe_tilt = result.x
	_strafe_tilt_vel = result.y
	
	return _strafe_tilt


func apply_offsets(delta: float) -> void:
	var idle_offset = _update_idle_sway(delta) if do_idle_sway else Vector3.ZERO
	var look_offset = _update_look_sway(delta) if do_look_sway else Vector3.ZERO
	var strafe_tilt = Vector3(0.0, 0.0, _update_strafe_tilt(delta))
	
	current_weapon_model.position = base_weapon_position + idle_offset + look_offset
	current_weapon_model.rotation = base_weapon_rotation + strafe_tilt
