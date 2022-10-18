extends Sprite2D

var worst_hit = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.worst_hit > worst_hit:
		worst_hit += delta
	
	material.set_shader_parameter("life", Global.health/float(Global.MAX_HP))
	material.set_shader_parameter("fade", worst_hit)
