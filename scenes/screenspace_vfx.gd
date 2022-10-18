extends TextureRect

var size_0 = [0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var s0_index = 0
var size_1 = [0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var s1_index = 0
var size_2 = [0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var s2_index = 0
var size_3 = [0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var s3_index = 0

func _ready():
	#load user settings here for this
	if !Global.user_settings.shockwaves:
		queue_free()
	
	material.set_shader_parameter("force", Global.user_settings.shockwave_force)
	material.set_shader_parameter("feather", Global.user_settings.shockwave_feather)
	var ypos = 60 if Global.user_settings.reverse_scroll else 660
	material.set_shader_parameter("center_0", Vector2(384,ypos) )
	material.set_shader_parameter("center_1", Vector2(554,ypos) )
	material.set_shader_parameter("center_2", Vector2(724,ypos) )
	material.set_shader_parameter("center_3", Vector2(896,ypos) )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for x in range(16):
		if size_0[x] > 0: size_0[x] += delta*5
		if size_0[x] > 3: size_0[x] = 0
		if size_1[x] > 0: size_1[x] += delta*5
		if size_1[x] > 3: size_1[x] = 0
		if size_2[x] > 0: size_2[x] += delta*5
		if size_2[x] > 3: size_2[x] = 0
		if size_3[x] > 0: size_3[x] += delta*5
		if size_3[x] > 3: size_3[x] = 0
	material.set_shader_parameter("size_0", size_0)
	material.set_shader_parameter("size_1", size_1)
	material.set_shader_parameter("size_2", size_2)
	material.set_shader_parameter("size_3", size_3)
	
func _input(event):
	if event.is_action_pressed("col_0"):
		size_0[s0_index] = 0.0001
		s0_index = (s0_index+1)%16
	if event.is_action_pressed("col_1"):
		size_1[s1_index] = 0.0001
		s1_index = (s1_index+1)%16
	if event.is_action_pressed("col_2"):
		size_2[s2_index] = 0.0001
		s2_index = (s2_index+1)%16
	if event.is_action_pressed("col_3"):
		size_3[s3_index] = 0.0001
		s3_index = (s3_index+1)%16
