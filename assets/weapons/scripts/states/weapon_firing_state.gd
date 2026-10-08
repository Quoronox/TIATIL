extends WeaponBaseState
class_name Weapon_Firing_State

@export var debug_mode: bool = false

#------------------------------<states that this current state is able to access>-----------------------------------
@export var weapon_idle_state : WeaponBaseState
@export var weapon_empty_state : WeaponBaseState
#-------------------------------------------------------------------------------------------------------------------



#------------------------------<initialization & cleanup>-----------------------------------------------------------
func enter_state():
	if debug_mode: DevConsole._push_complete("WFS - state activated")
	weapon_controller.fire_weapon()
	
	

func exit_state():
	if debug_mode: DevConsole._push_complete("WFS - state diactivated")
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<Current state loop>-----------------------------------------------------------------
func process_physics(delta: float) -> WeaponBaseState:
	if not weapon_controller:
		if debug_mode: DevConsole._push_error("ERROR: WFS - Could not find: weapon_contorller")
		return null
	
	if weapon_controller.current_ammo <= 0:
		if debug_mode: DevConsole._push_info("WFS - out of ammo")
		return weapon_empty_state
	
	return weapon_idle_state
	return null


func process_input(event: InputEvent) -> WeaponBaseState:
	return null
