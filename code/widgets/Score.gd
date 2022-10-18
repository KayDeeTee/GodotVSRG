extends Node2D

var sprites = []
var combo = 0
var renderCombo = 0
var digits = []

var comboSprites = []

var COMBO_LOSS_DELAY = .05
var combo_loss_timer = 0
 
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.score = self
	for x in range(10):
		comboSprites.append( load("res://sprites/combo"+str(x)+".png") )
	update_score(combo)

func update_score(c):
	var prev_digits = [] + digits
	
	c = int(floor(c))
	combo = c
	if combo > renderCombo:
		renderCombo = combo
	digits.clear()
	c = renderCombo
	while c > 0:
		digits.append(c%10)
		c = floor(c/10)
	while len(digits) < 7:
		digits.append(0)
	digits.reverse()
	update_sprites()
	
	if prev_digits != digits:
		for x in range( max(len(digits), len(prev_digits)) ):
			if x < len(digits) and x < len(prev_digits):
				if digits[x] != prev_digits[x]:
					sprites[x].t = 0 
			else:
				sprites[x].t = 0 
	
	
func update_sprites():
	while len(sprites)<len(digits):
		sprites.append(ComboSprite.new())
		sprites[len(sprites)-1].z_index = 75
		sprites[len(sprites)-1].scale = Vector2(.5,.5)
		add_child(sprites[len(sprites)-1])
	
	var center = (len(digits)-1)/2.0
	for x in range(len(sprites)):
		if x < len(digits):
			sprites[x].modulate.a = 1
			sprites[x].texture = comboSprites[digits[x]]
			sprites[x].position.x = (x-center)*40
		else:
			sprites[x].modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	combo_loss_timer += delta
	while combo_loss_timer > COMBO_LOSS_DELAY:
		combo_loss_timer -= COMBO_LOSS_DELAY
		if combo < renderCombo:
			renderCombo -= int(ceil(renderCombo/10.0)+1)
			update_score(combo)
		
