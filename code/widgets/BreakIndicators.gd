extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.user_settings.reverse_scroll:
		global_position.y *= -1
		scale.y = -1
