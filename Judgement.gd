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
		
	modulate.a = 1-(t/FADE_TIME)
