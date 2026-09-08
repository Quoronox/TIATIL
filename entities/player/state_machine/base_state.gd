class_name Base_State
extends Node

signal state_finished

@export var actor: Player

func enter_state():
	pass

func exit_state():
	pass

func process_physics(delta: float) -> Base_State:
	return null

func process_input(event: InputEvent) -> Base_State:
	return null

func process_frame(delta: float) -> Base_State:
	return null
