extends Sprite2D

@export
var col : int

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.break_spr[col] = self
	self_modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self_modulate.a -= delta
