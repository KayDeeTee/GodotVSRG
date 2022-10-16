extends Node2D

var y_pos = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.receptor_con = self
	if Global.user_settings.reverse_scroll:
		global_position.y = -y_pos
	else:
		global_position.y = y_pos
