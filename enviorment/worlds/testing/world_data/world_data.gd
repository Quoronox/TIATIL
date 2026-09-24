extends Node3D
class_name World

@export var player: Player
@export var doors: Array[Door] = []
@export var debug_mode: bool = false
var data: WorldDataHandoff


func _ready() -> void:
	player.disable()
	if debug_mode: print("World: " +str(data) + " : this is from data")
	if data == null:
		init_scene()
		start_scene()

func get_data() -> WorldDataHandoff:
	return data



func receive_data(_data) -> void:
	if debug_mode:print("World: Got data")
	if _data is WorldDataHandoff:
		data = _data
	else:
		push_warning("World %s is receiving data it cannot process" % name)


func init_scene() -> void:
	init_player_location()


func start_scene() -> void:
	player.enable()
	_connect_to_doors()


func init_player_location() -> void:
	player.visible = true
	if debug_mode: print("World: init_player_location")
	
	if data != null:
		if debug_mode: print("World: data not <null>")
		for door in doors:
			if door.name == data.entry_door_name:
				if debug_mode: print("World: Retrieved door connections")
				#player.position = door.get_player_entry_vector()
				player.position = Vector3(0,0,0)



func _on_player_entered_door(door: Door) -> void:
	if debug_mode: print("World: _on_player_entered_door")
	_disconnect_from_doors()
	
	player.disable()
	#player.queue_free()
	data = WorldDataHandoff.new()
	data.entry_door_name = door.entry_door_name
	data.move_direction = door.get_move_direction()


func _connect_to_doors() -> void:
	if debug_mode: print("World: _connect_to_doors")
	for door in doors:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)


func _disconnect_from_doors() -> void:
	if debug_mode: print("World: _disconnect_from_doors")
	for door in doors:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)
