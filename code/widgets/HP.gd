extends TextureProgressBar

var hp = 1.0

func _ready():
	Global.hp = self
	value = (Global.health/float(Global.MAX_HP))*max_value
	
	
