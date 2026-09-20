class_name Crouch_State
extends Base_State

#------------------------------<states that this current state is able to access>-----------------------------------
@export var idle_state : Base_State
@export var walk_state : Base_State
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<initialization & cleanup>-----------------------------------------------------------
func enter_state():
	set_physics_process(true)
	print("enter state: crouch")
	actor.trauma_causer.cause_trauma(0.2)
	
	#actor.animation_player.play("to_crouch", -1, -7.0, true)
	#actor.collider.shape.height = 1.5
	#actor.collider.position.y = -0.5
	
	
	

func exit_state():
	set_physics_process(false)
	#actor.animation_player.play("to_crouch", -1, 7.0)
	#actor.collider.position.y = 0.0
	#actor.collider.shape.height = 2.0
	
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<Current state loop>-----------------------------------------------------------------
func process_physics(delta: float) -> Base_State:
	print("in crouch")
	var input_direction = Input.get_vector("left","right","forward","back")
	var direction = (actor.head_y.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	var target_velocity = direction * actor.speed * 0.3
	var horizontal_velocity = Vector3(actor.velocity.x, 0, actor.velocity.z)
	
	horizontal_velocity = horizontal_velocity.move_toward(target_velocity, delta * actor.acceleration)
	
	actor.velocity.x = horizontal_velocity.x
	actor.velocity.z = horizontal_velocity.z
	
	if !actor.is_on_floor():
		actor.velocity.y -= actor.gravity * delta
	
	actor.move_and_slide()
	return null


func process_input(event: InputEvent) -> Base_State:
	if (Input.is_action_pressed("crouch") == false) && Input.is_action_pressed("movment")  && (actor.ceiling_check_cast.is_colliding() == false):
		var tween = get_tree().create_tween()
		tween.tween_property(actor, "height", 1.2, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).from_current()
		actor.animation_player.play("to_crouch", -1, 7.0)
		actor.trauma_causer.cause_trauma(0.7)
		return walk_state
	if Input.is_action_just_released("crouch") && (actor.ceiling_check_cast.is_colliding() == false):
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property(actor, "height", 1.2, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).from_current()
		actor.animation_player.play("to_crouch", -1, -7.0, true)
		actor.trauma_causer.cause_trauma(0.6)
		return idle_state
	
	return null


func process_frame(delta: float) -> Base_State:
	return null
#-------------------------------------------------------------------------------------------------------------------
