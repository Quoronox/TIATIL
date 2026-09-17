class_name FiniteStateMachine
extends Node

@export var state : Base_State

func init(_parent: Player):
	for child in get_children():
		print(child)
	
	change_state(state)

func change_state(new_state: Base_State):
	if state is Base_State:
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

func process_frame(delta: float):
	var new_state = state.process_frame(delta)
	if new_state:
		change_state(new_state)
