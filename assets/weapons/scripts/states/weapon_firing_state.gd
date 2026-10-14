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
	
	return null


func process_input(event: InputEvent) -> WeaponBaseState:
	# check fire mode
	if weapon_controller.current_weapon.is_automatic:
		# Automatic
		if Input.is_action_pressed("weapon_primary"):
			if weapon_controller.can_fire():
				weapon_controller.fire_weapon()
		else:
			# trigger released -> return to idle
			return weapon_idle_state
	
	else:
		# Semi-automatic
		return weapon_idle_state
		
	return null
