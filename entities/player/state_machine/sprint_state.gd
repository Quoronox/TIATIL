class_name Sprint_State
extends Base_State

#------------------------------<states that this current state is able to access>-----------------------------------
@export var idle_state : Base_State
@export var walk_state : Base_State
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<initialization & cleanup>-----------------------------------------------------------
func enter_state():
	set_physics_process(true)
	print("enter state: sprint")
	

func exit_state():
	set_physics_process(false)
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<Current state loop>-----------------------------------------------------------------
func process_physics(delta: float) -> Base_State:
	var input_direction = Input.get_vector("left","right","forward","back")
	var direction = (actor.head.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	var target_velocity = direction * actor.speed * 1.5
	var horizontal_velocity = Vector3(actor.velocity.x, 0, actor.velocity.z)
	
	horizontal_velocity = horizontal_velocity.move_toward(target_velocity, delta * actor.acceleration)
	
	actor.velocity.x = horizontal_velocity.x
	actor.velocity.z = horizontal_velocity.z
	
	if !actor.is_on_floor():
		actor.velocity.y -= actor.gravity * delta
	
	actor.move_and_slide()
	return null

func process_input(event: InputEvent) -> Base_State:
	if Input.is_action_just_released("shift"):
		var tween = get_tree().create_tween()
		tween.tween_property(actor, "fov", 90.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).from_current()
		return walk_state
	
	if Input.is_action_just_released("movment"):
		return idle_state
	
	return null

func process_frame(delta: float) -> Base_State:
	if (abs(actor.velocity.x) + abs(actor.velocity.z)) > 2.5:
		actor.animation_player.play("run")
	return null
#-------------------------------------------------------------------------------------------------------------------
