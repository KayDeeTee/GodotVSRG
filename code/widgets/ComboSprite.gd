extends Sprite2D
class_name ComboSprite

var t = 0
var def_scale = Vector2(0.5,0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta*20
	scale = def_scale * lerp( Vector2(0.4,.4), Vector2(1.0,1.0), clamp(t,0,1) )
