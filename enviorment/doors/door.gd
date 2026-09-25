extends Area3D
class_name Door

signal player_entered_door(door: Door, transition_type: String)

@export_enum("north", "west", "south", "east") var entry_direction
@export_enum("fade_to_black", "fade_to_diamond", "fade_to_swirl") var transition_type: String
@export var push_distance: int = 150
@export var path_to_new_scene: String
@export var entry_door_name: String
@export var debug_mode: bool = false


func _on_body_entered(body):
	if !body.is_in_group("player"):
		return
	player_entered_door.emit(self)
	if debug_mode: print("Door: Entered Door")
	
	var gameplay_node: GameManager = get_tree().get_nodes_in_group("game_manager")[0] as GameManager
	var unload:Node = gameplay_node.current_world
	
	SceneManager.load_new_scene(path_to_new_scene, gameplay_node.world_holder, unload, transition_type)
	queue_free()


func get_move_direction():
	var direction: Vector3 = Vector3.RIGHT
	match entry_direction:
		0:
			direction = Vector3.DOWN
		1:
			direction = Vector3.LEFT
		2:
			direction = Vector3.UP
	return direction
