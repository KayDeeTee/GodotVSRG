extends Sprite2D

var FADE_TIME = 0.5
var t = FADE_TIME

var textures = []
var sparks = []

func judge(j):
	t = 0
	texture = textures[j]
	
func _ready():	
	Global.judge = self
	
	textures.append(preload("res://sprites/MA.png"))
	textures.append(preload("res://sprites/PF.png"))
	textures.append(preload("res://sprites/GR.png"))
	textures.append(preload("res://sprites/GD.png"))
	textures.append(preload("res://sprites/BD.png"))
	textures.append(preload("res://sprites/MS.png"))
	
	sparks.append(preload("res://sprites/jsparkma.png"))
	sparks.append(preload("res://sprites/jsparkpf.png"))
	sparks.append(preload("res://sprites/jsparkgr.png"))
	sparks.append(preload("res://sprites/jsparkgd.png"))
	sparks.append(preload("res://sprites/jsparkbd.png"))
	sparks.append(preload("res://sprites/jsparkms.png"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if t < FADE_TIME:
		t += delta

	var inv_time = 1.0-(t/FADE_TIME)
	scale = Vector2(.5,.5)*lerp(1.0, .6, 1.0-(inv_time*inv_time))
	rotation = lerp(0.0,-deg_to_rad(25.0), 1.0-(inv_time*inv_time))
	modulate.a = 1-(t/FADE_TIME)
