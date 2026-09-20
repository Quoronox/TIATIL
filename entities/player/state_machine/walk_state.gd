class_name Walk_State
extends Base_State

#------------------------------<states that this current state is able to access>-----------------------------------
@export var idle_state : Base_State
@export var sprint_state : Base_State
@export var crouch_state : Base_State
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<initialization & cleanup>-----------------------------------------------------------
func enter_state():
	set_physics_process(true)
	print("enter state: walk")
	actor.trauma_causer.cause_trauma(0.4)
	

func exit_state():
	set_physics_process(false)
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<Current state loop>-----------------------------------------------------------------
func process_physics(delta: float) -> Base_State:
	var input_direction = Input.get_vector("left","right","forward","back")
	var direction = (actor.head_y.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	var target_velocity = direction * actor.speed
	var horizontal_velocity = Vector3(actor.velocity.x, 0, actor.velocity.z)
	
	horizontal_velocity = horizontal_velocity.move_toward(target_velocity, delta * actor.acceleration)
	
	actor.velocity.x = horizontal_velocity.x
	actor.velocity.z = horizontal_velocity.z
	
	if !actor.is_on_floor():
		actor.velocity.y -= actor.gravity * delta
	
	actor.move_and_slide()
	return null

func process_input(event: InputEvent) -> Base_State:
	if Input.is_action_pressed("shift"):
		var tween = get_tree().create_tween()
		tween.tween_property(actor, "fov", 100.0, 1.0).from_current()
		return sprint_state
	
	if Input.is_action_pressed("crouch") or ((actor.ceiling_check_cast.is_colliding())):
		var tween = get_tree().create_tween()
		tween.tween_property(actor, "height", 0.2, 0.4).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT).from_current()
		actor.animation_player.play("to_crouch", -1, 7.0)
		return crouch_state
	
	if Input.is_action_pressed("movment") == false:
		var tween = get_tree().create_tween()
		tween.tween_property(actor, "fov", 90.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).from_current()
		return idle_state
	return null

func process_frame(delta: float) -> Base_State:
	if (abs(actor.velocity.x) + abs(actor.velocity.z)) > 1.5:
		actor.animation_player.play("walk")
	return null
#-------------------------------------------------------------------------------------------------------------------
