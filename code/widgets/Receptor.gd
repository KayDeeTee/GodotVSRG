extends Sprite2D

@export
var input_str:String
var tex_p = preload("res://sprites/receptor-pressed.png")
var tex_u = preload("res://sprites/receptor-unpressed.png")

func _input(event):
	if event.is_action_pressed(input_str):
		texture = tex_p
	if event.is_action_released(input_str):
		texture = tex_u
