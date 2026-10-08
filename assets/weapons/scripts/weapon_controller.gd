extends Node
class_name WeaponController

@export var debug_mode: bool = false

@export var camera: Camera3D
@export var current_weapon: Weapon
@export var weapon_model_parent: Node3D



var current_weapon_model: Node3D
var current_ammo: int


func _ready() -> void:
	if current_weapon:
		spawn_weapon_model()
		current_ammo = current_weapon.max_ammo


func spawn_weapon_model():
	if current_weapon_model:
		current_weapon_model.queue_free()
		if debug_mode: DevConsole._push_warning("WC - removed duplicate current_weapon_model")
	
	if current_weapon.weapon_model:
		if debug_mode: DevConsole._push_info("WC - added current_weapon_model")
		current_weapon_model = current_weapon.weapon_model.instantiate()
		weapon_model_parent.add_child(current_weapon_model)
		current_weapon_model.position = current_weapon.weapon_position


func can_fire() -> bool:
	return (current_ammo > 0)


func fire_weapon() -> void:
	if can_fire():
		current_ammo -= 1
		
		
