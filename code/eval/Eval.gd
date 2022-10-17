extends Node2D

@onready
var graph = get_node("../ui/Graph")
@onready
var counts = get_node("../ui/count_bg/counts")
@onready
var grade = get_node("../ui/grade")
@onready
var accuracy = get_node("../ui/acc")
@onready
var songtitle = get_node("../ui/songtitle")

var judgements = [0,0,0,0,0,0,0,0]

func test_graph():
	Global.results.reset()
	for x in range(-180,181):
		Global.results.add_hit(x+180,x*1000,false,false)
	Global.results.song_start = 0
	Global.results.song_end = 361

func get_judge(t):
	for x in range(len(Global.windows)):
		if abs(t) < Global.windows[x]:
			return x
	return 5

# Called when the node enters the scene tree for the first time.
func _ready():
	if len(Global.results.hits)==0: #for debug usage
		test_graph()
	
	var image = Image.new()
	var image_texture = ImageTexture.new()
	
	image.create(720,360, false,Image.FORMAT_RGBA8)
	var acc = 0
	var mAcc = 0
	for note in Global.results.hits:
		if !is_note_hold_info(note):
			acc += Global.wife3(note.offset/float(1000000), 1)
			mAcc += 2
			judgements[get_judge(note.offset)] += 1
			var note_c = Global.colors[Global.window_from_offset(note.offset)]			
			var offset = clamp(floor(note.offset/1000.0),-180,179)
			var song_pos = clamp(floor(get_hit_song_percent(note)*720),0,719)
			image.set_pixel(song_pos,180+offset, note_c)
			
		else:
			if note.type == Global.results.HitInfoType.NO_GOOD:
				judgements[7] += 1
			else:
				judgements[6] += 1
	
	acc = (acc/float(mAcc))*100.0
	var g = Global.WifeAccToGrade(acc)
	var g2 = g.replace(".","").replace(":","")
	set_grade(g, g2)
	
	accuracy.text = "[center]%.2f%%[/center]" % acc
				
	counts.text = "[right]"
	for x in range(6):
		counts.text += str(judgements[x])
		counts.text += "\n"
	counts.text += str(judgements[6])+"/"+str(judgements[6]+judgements[7])
	counts.text += "[/right]"
	
	songtitle.text = "[center][color=#fff]%s\n[font_size=32]%s[/font_size][/color][/center]" % [Global.results.title, Global.results.artist]
			
	image_texture = ImageTexture.create_from_image(image)
	graph.texture = image_texture

func set_grade(subgrade, _grade):
	grade.text = "[center][color=%s]%s[/color][/center]" % [Global.colours["grade"][_grade],subgrade]

func is_note_hold_info(note): #checks if a hitinfo is an actual note or hold extra notes
	return note.type == Global.results.HitInfoType.NO_GOOD or note.type == Global.results.HitInfoType.OK
	
func get_hit_song_percent(note):
	return note.time/float(Global.results.song_end-Global.results.song_start)
