extends CanvasLayer

@onready var text_field : RichTextLabel =$MarginContainer/VBoxContainer/RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	_push_text("testing")


# ----------write functions-----------------

func _push_text(text_input: String) -> void:
	if (text_input == null) or (text_field == null):
		return
	text_field.newline()
	text_field.append_text(text_input)


func _push_info(text_input: String) -> void:
	var formatted_text := (
		"[i]"
		+ "[font_size=11]"
		+ "[color=#3093bf]"
		+ "[outline_size=5]"
		+ "[outline_color=#1b59ab]"
		+ "[img=13x13]res://assets/icons/icons8-info.svg[/img]"
		+ text_input
		+ "[/outline_color]"
		+ "[/outline_size]"
		+ "[/color]"
		+ "[/font_size]"
		+ "[/i]"
	)
	if (text_input == null) or (text_field == null):
		return
	text_field.newline()
	text_field.append_text(formatted_text)


func _push_warning(text_input: String) -> void:
	var formatted_text := (
		"[b]"
		+ "[font_size=10]"
		+ "[color=#f2b230]"
		+ "[img=13x16]res://assets/icons/warning_icon.png[/img]"
		+ text_input
		+ "[/color]"
		+ "[/font_size]"
		+ "[/b]"
	)
	
	if (text_input == null) or (text_field == null):
		return
	text_field.newline()
	text_field.append_text(formatted_text)


func _push_error(text_input: String) -> void:
	var formatted_text := (
		"[b]"
		+ "[font_size=10]"
		+ "[color=#b02028]"
		+ "[outline_size=5]"
		+ "[outline_color=#851513]"
		+ "[img=13x13]res://assets/icons/error_icon.png[/img]"
		+ text_input
		+ "[/outline_color]"
		+ "[/outline_size]"
		+ "[/color]"
		+ "[/font_size]"
		+ "[/b]"
	)
	
	if (text_input == null) or (text_field == null):
		return
	text_field.newline()
	text_field.append_text(formatted_text)


func _push_complete(text_input: String) -> void:
	var formatted_text := (
		"[font_size=10]"
		+ "[color=#00bf60]"
		+ "[img=13x13]res://assets/icons/complete_icon.svg[/img]"
		+ text_input
		+ "[/color]"
		+ "[/font_size]"
	)
	
	if (text_input == null) or (text_field == null):
		return
	text_field.newline()
	text_field.append_text(formatted_text)


func _push_processing(text_input: String) -> void:
	var formatted_text := (
		"[font_size=10]"
		+ "[color=#2f5757]"
		+ "[img=13x13]res://assets/icons/loading_icon.png[/img]"
		+ text_input
		+ "[/color]"
		+ "[/font_size]"
	)
	
	if (text_input == null) or (text_field == null):
		return
	text_field.newline()
	text_field.append_text(formatted_text)
