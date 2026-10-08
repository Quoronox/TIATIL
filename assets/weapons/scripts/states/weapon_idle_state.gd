extends WeaponBaseState
class_name WeaponIdleState

@export var debug_mode: bool = false

#------------------------------<states that this current state is able to access>-----------------------------------
@export var weapon_firing_state : WeaponBaseState
@export var weapon_empty_state : WeaponBaseState
#-------------------------------------------------------------------------------------------------------------------



#------------------------------<initialization & cleanup>-----------------------------------------------------------
func enter_state() -> void:
	if debug_mode: DevConsole._push_complete("WIS - state activated")


func exit_state() -> void:
	if debug_mode: DevConsole._push_complete("WIS - state diactivated")
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<Current state loop>-----------------------------------------------------------------
func process_physics(delta: float) -> WeaponBaseState:
	#DevConsole._push_text("Idle process - weapon")
	if not weapon_controller:
		if debug_mode: DevConsole._push_error("ERROR: WIS - Could not find: weapon_contorller")
		return null
	
	if weapon_controller.current_ammo <= 0:
		if debug_mode: DevConsole._push_info("WIS - out of ammo")
		return weapon_empty_state
	return null


func process_input(event: InputEvent) -> WeaponBaseState:
	if Input.is_action_just_pressed("weapon_primary") and weapon_controller.can_fire():
		if debug_mode: DevConsole._push_complete("WIS - weapon activated")
		return weapon_firing_state
	return null
