extends Sprite2D

var fade_in = 4
var s_pos = Vector2(376, 536)

func _ready():
	Global.toastie = self
	if !Global.user_settings.toasties:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fade_in += delta
	var y_pos = 1-(1/float(fade_in+1.0))
	position = s_pos + Vector2(0,-720)*y_pos
	self_modulate.a = 3.0-fade_in
	
