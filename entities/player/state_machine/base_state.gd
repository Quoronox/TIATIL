class_name BaseState
extends Node

signal state_finished

@export var actor: Player

func enter_state():
	pass

func exit_state():
	pass

func process_physics(delta: float) -> BaseState:
	return null

func process_input(event: InputEvent) -> BaseState:
	return null

func process_frame(delta: float) -> BaseState:
	return null
