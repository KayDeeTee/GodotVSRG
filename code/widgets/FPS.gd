extends RichTextLabel

var t = 0
var RATE_LIMIT = 0.25
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	if t > RATE_LIMIT:
		t -= RATE_LIMIT
		text = "[right]%d UPS[/right]" % Engine.get_frames_per_second()
