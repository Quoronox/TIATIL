extends CharacterBody3D
class_name Player

@export var speed : int = 10
@export var acceleration : float = 100.0
@export var decceleration : float = 70.0
@export var fov : float = 90.0
@export var height : float = 1.2
@export var gravity : float = 9.8

@export_category("Mouse Sensitivity")
@export_range(1, 10) var mouse_sensitivity_horizontal: float = 1.5
@export_range(1, 10) var mouse_sensitivity_vertical: float = 1.3

@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collider = $CollisionShape3D
@onready var ceiling_check_cast = $CeilingCheckCast

var mouse_lock : bool = true

func _ready():
	fsm.init(self)
	lock_mouse_to_center()


func _input(event):
	if event is InputEventMouseMotion:
		if mouse_lock:
			head.rotate_y(-event.relative.x * 0.005 * mouse_sensitivity_horizontal)
			camera.rotate_x(-event.relative.y * 0.005 * mouse_sensitivity_vertical)
			
			var horizontal_mouse_direction = -(event.relative.x * 0.2 * mouse_sensitivity_horizontal)
			camera.rotation_degrees.z = (lerp(camera.rotation_degrees.z, horizontal_mouse_direction, 0.5))

		#self.camera_tilt = lerp(self.camera_tilt, horizontal_mouse_direction, 1)
		#self.vertical_rotation -= (event.relative.y * 0.0045 * mouse_sensitivity_vertical)
	


func lock_mouse_to_center() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.rotation_degrees.z = 0.0


func enable_mouse_lock() -> void:
	if mouse_lock:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if mouse_lock == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func update_player_values() -> void:
	camera.fov = self.fov
	head.position.y = self.height
	
	if Input.is_action_just_pressed("toggle_mouse_lock"):
		mouse_lock = !mouse_lock
		print(mouse_lock)
	enable_mouse_lock()
	
	#print($CollisionShape3D.shape.height)


# ------------------------Update FiniteStateMachine------------------------
# Try to not mix other functions in here (keep it clean)
func _physics_process(delta):
	fsm.process_physics(delta)


func _unhandled_input(event):
	fsm.process_input(event)


func _process(delta):
	fsm.process_frame(delta)
	update_player_values()
# -------------------------------------------------------------------------------
