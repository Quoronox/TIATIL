extends Node

@export var debug_mode: bool = false

@export var player: Player

@export var camera: DynamicCamera
@export var interaction_ray: ShapeCast3D
@export var hand: Marker3D


# Store interactable objects
var _current_object: Object
var _last_potential_object: Object
var interaction_component: Node


func _process(delta: float) -> void:
	return
