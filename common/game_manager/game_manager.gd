extends Node3D
class_name GameManager

@onready var world_holder: Node3D = $WorldHolder
@export var debug_mode: bool = false

var current_world # <- should allways be "World" or "IntermissionScreen"


func _ready():
	if debug_mode: print("GameManager: Is Created ")
	
	SceneManager.load_complete.connect(_on_world_loaded)
	SceneManager.load_start.connect(_on_load_start)
	SceneManager.scene_added.connect(_on_world_added)
	current_world = world_holder.get_child(0)


func _on_world_loaded(world):
	if world is World:
		current_world = world


func _on_world_added(_world,_loading_screen):
	pass
	# keep loading screen on top
	if _loading_screen != null:
		var loading_parent: Node = _loading_screen.get_parent() as Node
		loading_parent.move_child(_loading_screen, loading_parent.get_child_count()-1)


func _on_load_start(_loading_screen):
	pass
