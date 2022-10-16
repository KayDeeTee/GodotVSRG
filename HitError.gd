extends Sprite2D

var image:Image
var image_texture:ImageTexture
var t = 0
@onready
var avg_sprite = get_node("../hiterroravg")
var hitaverage = []
var hitaverageindex = 0
var avg = 0

#this class should be much better
#and yes its definitely me over engineering to solve a problem that probably doesn't exist

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.hiterror = self
	
	image = Image.new()
	image.create(360,1, false,Image.FORMAT_RGBA8)
	
	for x in range(360):
		image.set_pixel(x,0,Color(0,0,0,0))
	
	image_texture = ImageTexture.new()
	image_texture = ImageTexture.create_from_image(image)
	texture = image_texture

func _process(delta):
	t+=delta
	while t > .1:
		p50()
		t -= .1

func p50():
	for x in range(360):
		var c = image.get_pixel(x,0)
		c.a -= 0.025
		image.set_pixel(x,0,c)
	image_texture.update(image)
	texture = image_texture

func add_pixel(color, offset):
	
	if offset < 180:
		if len(hitaverage) < 100:
			hitaverage.append(offset)
		else:
			hitaverage[hitaverageindex] = offset
			hitaverageindex += 1
			hitaverageindex %= 100
			
		avg = 0
		for hit in hitaverage:
			avg += hit
		avg /= len(hitaverage)
		avg_sprite.position.x = avg
	
	if offset>=180:
		offset = 179
	image.set_pixel(180+offset,0,color)

