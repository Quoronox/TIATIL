extends WeaponBaseState
class_name WeaponEmptyState

@export var debug_mode: bool = false

#------------------------------<states that this current state is able to access>-----------------------------------
@export var weapon_firing_state : WeaponBaseState
@export var weapon_idle_state : WeaponBaseState
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<initialization & cleanup>-----------------------------------------------------------
func enter_state():
	print("WEAPON EMPTY")
	if debug_mode: DevConsole._push_complete("WES - state activated")
	if debug_mode: DevConsole._push_warning("WES - weapon empty")
	

func exit_state():
	if debug_mode: DevConsole._push_complete("WES - state diactivated")
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<Current state loop>-----------------------------------------------------------------
func process_physics(delta: float) -> WeaponBaseState:
	if not weapon_controller:
		if debug_mode: DevConsole._push_error("ERROR: WES - Could not find: weapon_contorller")
		return null
	# Example: check for reload input here..
	return null


func process_input(event: InputEvent) -> WeaponBaseState:
	return null
