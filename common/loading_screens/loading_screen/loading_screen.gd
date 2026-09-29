extends CanvasLayer
class_name LoadingScreen

signal transition_in_complete

@onready var progress_bar: ProgressBar = $Control/ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer


# ---Fade Screens---
@onready var fade_black: ColorRect = $Control/FadeBlack
@onready var fade_diamond: ColorRect = $Control/FadeDiamond
@onready var fade_swirl: ColorRect = $Control/FadeSwirl

var starting_animation_name: String

func _ready():
	progress_bar.visible = false
	animation_player.play("RESET")


func start_transition(animation_name:String) -> void:
	if !animation_player.has_animation(animation_name):
		push_warning("'%s' animation does not exist" % animation_name)
		animation_name = "fade_to_black"
	starting_animation_name = animation_name
	animation_player.play(animation_name)
	
	timer.start()
	

func finish_transition() -> void:
	if timer:
		timer.stop()
	
	var ending_animation_name: String = starting_animation_name.replace("to","from")
	
	if !animation_player.has_animation(ending_animation_name):
		push_warning("'%s' animation does not exist" % ending_animation_name)
		ending_animation_name = "fade_from_black"
	animation_player.play(ending_animation_name)
	
	await animation_player.animation_finished
	queue_free()


func report_midpoint() -> void:
	transition_in_complete.emit()


func _on_timer_timeout() -> void:
	progress_bar.visible = true


func update_bar(_progress: float) -> void:
	#print("progress b")
	progress_bar.value = _progress
