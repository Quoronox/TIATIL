extends Area3D
class_name Projectile

var velocity: Vector3
var damage: float


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	get_tree().create_timer(30.0).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	#self.global_position += velocity * delta
	var space_state = get_world_3d().direct_space_state
	var start_pos = self.global_position
	var end_pos = global_position + velocity * delta
	
	var query = PhysicsRayQueryParameters3D.create(start_pos, end_pos)
	query.collision_mask = 2
	var result = space_state.intersect_ray(query)
	
	if result:
		self.global_position = result.position
		_on_body_entered(result.collider)
		return
	
	self.global_position = end_pos



func setup(init_velocity: Vector3, init_damage: float) -> void:
	velocity = init_velocity
	damage = init_damage


func _on_body_entered(body: Node3D) -> void:
	DevConsole._push_info("Projectile hit: " + str(body.name) + " at " + str(global_position))
	_spawn_impact_marker(global_position)
	queue_free()


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
