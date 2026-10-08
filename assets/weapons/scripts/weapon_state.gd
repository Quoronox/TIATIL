extends Node
class_name WeaponBaseState

signal state_finished


@export var weapon_state_machine: WeaponStateMachine


var weapon_controller: WeaponController


func _ready() -> void:
	if weapon_state_machine and (weapon_state_machine is WeaponStateMachine):
		weapon_controller = weapon_state_machine.weapon_controller


func enter_state() -> void:
	pass

func exit_state() -> void:
	pass


func process_physics(delta: float) -> WeaponBaseState:
	return null


func process_input(event: InputEvent) -> WeaponBaseState:
	return null
