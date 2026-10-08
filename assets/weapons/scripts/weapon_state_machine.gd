extends Node
class_name WeaponStateMachine

@export var debug_mode: bool = false

@export var weapon_controller: WeaponController
@export var state : WeaponBaseState


func init(_parent: Player):
	if debug_mode: DevConsole._push_complete("WSM - initialize")
	for child in get_children():
		pass
		#print(child)
	
	change_state(state)


func change_state(new_state: WeaponBaseState):
	if debug_mode: DevConsole._push_complete("WSM - change state to: " + str(new_state.name))
	if state is WeaponBaseState:
		state.exit_state()
	new_state.enter_state()
	state = new_state


func process_physics(delta: float):
	#print(state)
	var new_state = state.process_physics(delta)
	if new_state:
		change_state(new_state)


func process_input(event: InputEvent):
	var new_state = state.process_input(event)
	if new_state:
		change_state(new_state)
