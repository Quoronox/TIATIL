extends Base_State
class_name Idle_State

#------------------------------<states that this current state is able to access>-----------------------------------
@export var walk_state : Base_State
@export var crouch_state : Base_State
#-------------------------------------------------------------------------------------------------------------------


#------------------------------<initialization & cleanup>-----------------------------------------------------------
func enter_state():
	#print("enter idle")
	pass
	

func exit_state():
	#print("exit idle")
	pass
#-------------------------------------------------------------------------------------------------------------------



#------------------------------<Current state loop>-----------------------------------------------------------------
func process_physics(delta: float) -> Base_State:
	var target_velocity = Vector3(0,0,0)
	var horizontal_velocity = Vector3(actor.velocity.x, 0, actor.velocity.z)
	
	horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, delta * actor.decceleration)
	
	actor.velocity.x = horizontal_velocity.x
	actor.velocity.z = horizontal_velocity.z
	
	if !actor.is_on_floor():
		actor.velocity.y -= actor.gravity * delta
	
	actor.move_and_slide()
	
	return null

func process_input(event: InputEvent) -> Base_State:
	if Input.is_action_pressed("movment"):
		#print("idle -> walk")
		var tween = get_tree().create_tween()
		tween.tween_property(actor, "fov", 90.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).from_current()
		return walk_state
	if Input.is_action_pressed("crouch") or ((actor.ceiling_check_cast.is_colliding())):
		var tween = get_tree().create_tween()
		tween.tween_property(actor, "height", 0.2, 0.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT).from_current()
		actor.animation_player.play("to_crouch", -1, 7.0)
		return crouch_state
	return null

func process_frame(delta: float) -> Base_State:
	
	return null
#-------------------------------------------------------------------------------------------------------------------
