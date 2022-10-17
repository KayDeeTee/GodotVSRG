extends Sprite2D
class_name NoteObject

var c
var t
var r_pos

var t2
var h

var hold_missed = false
var hold_completed = false
var isheld = false
var life = Global.HOLD_LIFE
var button_pressed = false

var hold_obj
var hold_tip

var y_mul = 1

func hit():
	if !h:
		remove()
	else:
		isheld = true
		button_pressed = true
		life = Global.HOLD_LIFE

func completed():
	hold_completed = true

func release():
	button_pressed = false
	
func missed():
	if !h:
		remove()
	else:
		hold_missed = true
		life = 0

func remove():
	queue_free()

func _ready():
	z_index = 50
	if Global.user_settings.reverse_scroll:
		y_mul = -1
	if h:
		hold_obj = Sprite2D.new()
		hold_obj.texture = preload("res://sprites/hold_body.png")
		hold_obj.z_as_relative = true
		hold_obj.z_index = -1
		hold_obj.use_parent_material = true
		add_child(hold_obj)
		
		hold_tip = Sprite2D.new()
		hold_tip.texture = preload("res://sprites/hold_tip.png")
		hold_tip.z_as_relative = true
		hold_tip.z_index = -1
		hold_tip.offset.y = -8
		hold_tip.use_parent_material = true
		add_child(hold_tip)
	
	update_pos()

func sv_t():
	return Global.get_sv_time(t+Global.user_settings.note_visual_offset)
func sv_t2():
	return Global.get_sv_time(t2+Global.user_settings.note_visual_offset)
func sv_st():
	return Global.get_song_sv_time()
	
func update_pos():
	if isheld:
		position = r_pos
	else:
		position = r_pos - Vector2(0,(sv_t()-sv_st())/1000.0)
	position.y *= y_mul
	if h:
		var tip_y = (sv_t2()-sv_st())/1000.0
		if isheld and tip_y < 0:
			tip_y = 0
		hold_tip.global_position = r_pos - Vector2(0,tip_y)
		hold_tip.global_position.y *= y_mul
		hold_tip.scale.y = y_mul
		
		hold_obj.global_position.y = (hold_tip.global_position.y + global_position.y)/2.0
		hold_obj.scale.y = (global_position.y-hold_tip.global_position.y)/2.0
		
func _process(delta):
	update_pos()
	
	if isheld and not button_pressed:
		life -= delta
	if isheld or hold_missed:
		modulate.a = 0.5 + max(life,0)*2
	if hold_missed:
		if Global.song_time()-t2 > Global.windows[Global.WINDOWS.BD]:
			remove()
	if hold_completed:
		if Global.song_time()-t2 > 0:
			remove()
		
		
		
