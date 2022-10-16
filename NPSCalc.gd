extends Sprite2D

var window = 1.0 #seconds

var detail = 128
var freq = 0.1
var notes = []
var note_sum = 0
var max_nps = 40

var time = 0

var image:Image
var image_texture:ImageTexture

func add_note(t):
	notes.append(t)
	note_sum += 1
	
func remove_notes():
	var check = len(notes) > 0
	while check:
		check = false
		if (notes[0] + (window*1000000)) < Global.song_time():
			note_sum -= 1
			notes.remove_at(0)
			check = true
		check = check and (len(notes) > 0)
		
func current_nps():
	return note_sum / window

func _ready():
	Global.nps = self
	
	if !Global.user_settings.nps:
		queue_free()
	
	image = Image.new()
	image.create(detail,64, false,Image.FORMAT_RGBA8)
	
	for x in range(detail):
		image.set_pixel(x,0,Color(0,0,0,1))
	
	image_texture = ImageTexture.create_from_image(image)
	texture = image_texture
	
func update_graph():
	image.blit_rect(image, Rect2(1,0,detail-1,1),Vector2(0,0))
	
	var height = clamp(current_nps() / max_nps,0,1)
	
	image.set_pixel(detail-1,0, Color(height,0,0,0))
	
	var cnps = current_nps()
	image.set_pixel(0,0, Color(image.get_pixel(0,0).r, floor(cnps/10)/9.0, (int(cnps)%10)/9.0, 0));
	
	image_texture.update(image)
	texture = image_texture

func _process(delta):
	time += delta
	while time > freq:
		remove_notes()
		time -= freq
		update_graph()
