extends Node2D

#this is not exactly how you should store charts
var chart = """
0:2000000;
1:2500000;
2:3000000;
3:3000000;
2:3500000:4000000;
0:5300000;
1:5400000;
2:5500000;
3:5600000;
"""

#but im lazy
var sv = """
1:0;
1:3.5;
1:4;
1:4.5;
1:5.0;
"""

var n_mat = preload("res://Material/Hidden.tres")

var cScore = 0
var mScore = 0

var osuScore = 0
var osumScore = 0

var scroll_vels = []

var columns = []
var column_count = 4

var spawned_notes = []

var audio = null
var clap = null
var hitsound =  null

var time
var t_song_zero
var spawn_distance = 500000
var t_begin = 0
var t_delay = 0
var alreadyplayed = false
var song_duration = 0

var combo = 0

const usec = 1000000

var sv_lookup_start = 0

var clap_times = []
var clap_index = 0

#this is just so scroll velocities work
func get_adjusted_time(in_time, update_min=false):
	var sv_index = -1
	for svi in range(sv_lookup_start, len(scroll_vels)):
		var vel_change = scroll_vels[svi]
		if vel_change.y > in_time:
			sv_index = svi
			break
	if update_min:
		sv_lookup_start = sv_index
	if sv_index == 0:
		return in_time
	if sv_index != -1:
		var lerp_amount = (float(in_time)-scroll_vels[sv_index-1].y)/(scroll_vels[sv_index].y-scroll_vels[sv_index-1].y)
		return lerp(scroll_vels[sv_index-1].z, scroll_vels[sv_index].z, lerp_amount)
	sv_index = len(scroll_vels)-1
	
	var out_time = ((in_time-scroll_vels[sv_index].y)*scroll_vels[sv_index].x)+scroll_vels[sv_index].z
	
	return out_time

var audiofilename = ""
var audioleadin = 0
var bpm = -1

func parse_osu(directory, file):
	var f = FileAccess.open(directory+file, FileAccess.READ)
	var lines = f.get_as_text().split("\n",false)
	var parsemode = null
	var last_notes = []
	var last_sv_time = 0
	var prev_sv_vel = 1
	for x in range(column_count):
		last_notes.append(null)
	for line in lines:
		if line[0] == "[":
			parsemode = line
			parsemode = parsemode.left(-2)
			parsemode = parsemode.right(-1)
			print(parsemode)
		if parsemode == "General":
			if line.begins_with("AudioFilename:"):
				audiofilename = line.split(":")[1]
			if line.begins_with("AudioLeadIn:"):
				var _audioleadin = line.split(":")[1].to_int()
				if _audioleadin > 0:
					audioleadin = _audioleadin
		if parsemode == "Metadata":
			if line.begins_with("Title:"):
				Global.set_title(line.split(":")[1])
		if parsemode == "TimingPoints":
			var sv = line.split(",")
			if len(sv) < 2:
				continue
			var sv1 = sv[1].to_float()
			if bpm == -1 and sv1 > 0:
				bpm = sv1
			var velocity = 1
			if sv1 < 0:
				velocity = (100.0)/abs(sv1)
				var v = 1-velocity
				velocity = 1+(v/16.0)
			
			var vel_time = last_sv_time
			last_sv_time = (sv[0].to_int()+audioleadin)*1000
			scroll_vels.append( Vector3(velocity, vel_time, 0) )
		if parsemode == "HitObjects":
			var note = line.split(",",false)
			if len(note) < 5:
				continue
			var n = NoteInfo.new()
			osumScore += 320
			n.c = (note[0].to_int()-64)/128
			n.t = note[2].to_int()*1000+(audioleadin*1000)
			
			if note[3].to_int() == 128:
				n.t2 = note[5].split(":")[0].to_int()*1000+(audioleadin*1000)
				n.h = true
			else:
				n.h = false
				
			if len(clap_times) == 0:
				clap_times.append(n.t)
			else:
				if clap_times[len(clap_times)-1] < n.t:
					clap_times.append(n.t)
				
			if columns[n.c] == null:
				columns[n.c] = n
			else:
				last_notes[n.c].n = n
			last_notes[n.c] = n
			
	for x in range(column_count):
		if last_notes[x].t > song_duration:
			song_duration = last_notes[x].t
		if last_notes[x].h:
			if last_notes[x].t2 > song_duration:
				song_duration = last_notes[x].t2


func _ready():
	Global.composer = self
	
	t_song_zero = Time.get_ticks_usec()+(3*usec)
	
	n_mat.set_shader_parameter("h_end_y", Global.user_settings.hidden_end_y)
	n_mat.set_shader_parameter("h_start_y", Global.user_settings.hidden_start_y)
	n_mat.set_shader_parameter("s_end_y", Global.user_settings.sudden_end_y)
	n_mat.set_shader_parameter("s_start_y", Global.user_settings.sudden_start_y)
	
	t_begin = Time.get_ticks_usec()
	var last_notes = []
	for x in range(column_count):
		columns.append(null)
		last_notes.append(null)
		spawned_notes.append([])
	
	audio = get_node("../audio")
	clap = get_node("../clap")
	hitsound = get_node("../hitsound")
	
	parse_osu("res://song/", "chart.osu")
	
	for x in range(1,len(scroll_vels)):
		scroll_vels[x].z = scroll_vels[x-1].z + scroll_vels[x-1].x*(scroll_vels[x].y-scroll_vels[x-1].y)
	
	#the scroll vels from osu arent compatible for some reason with my sv method so just ignore them ig 	
	#scroll_vels = [Vector3(1,0,0)]

				
func _process(delta):
	time = Global.song_time()
	
	Global.SetProgress(time/song_duration)
	
	if time >= 0 and !audio.playing and !alreadyplayed:
		t_song_zero = Time.get_ticks_usec()
		t_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
		audio.play(0)
		alreadyplayed = true
	
	check_to_spawn_notes()
	check_to_despawn_notes()
	check_to_play_clap()
	
func check_to_play_clap():
	if !Global.user_settings.clap:
		return
	if clap_index < len(clap_times):
		var ct = clap_times[clap_index]
		var _time = Global.song_time()+Global.user_settings.note_global_offset-ct
		if _time > 0:
			clap.play(0)
			clap_index += 1
		

func check_to_spawn_notes():
	for x in range(column_count):
		var cf = columns[x]
		var check = cf != null
		while check and cf.t < Global.song_time()+spawn_distance+Global.user_settings.note_global_offset:
			spawn_note(cf)
			columns[x] = cf.n
			cf = cf.n
			check = cf != null
			
func spawn_note(noteinfo):
	var note = NoteObject.new() #this should be pooled but dont at me
	note.texture = preload("res://sprites/note.png")
	note.texture_filter = note.TEXTURE_FILTER_NEAREST
	
	note.material = n_mat;
	
	note.scale = Vector2(2,2)
	note.c = noteinfo.c
	note.t = noteinfo.t
	note.t2 = noteinfo.t2
	note.h = noteinfo.h
	
	note.r_pos = Vector2(-144+noteinfo.c*96,300)
	
	spawned_notes[note.c].append(note)
	
	add_child(note)

func check_to_despawn_notes():
	var _time = Global.song_time()+Global.user_settings.note_global_offset
	for col in range(column_count):
		if len(spawned_notes[col]) > 0:
			var n = spawned_notes[col][0]
			if n != null:
				if n.h:
					if n.isheld:
						if n.life < 0:
							n.missed()
							handle_score(n, Global.windows[Global.WINDOWS.BD])
							spawned_notes[col].remove_at(0)
						if _time-n.t2 > Global.windows[Global.WINDOWS.BD]-n.life*usec:
							n.completed()
							spawned_notes[col].remove_at(0)
					else:
						if _time-n.t > Global.windows[Global.WINDOWS.BD]:
							n.missed()
							handle_score(n, Global.windows[Global.WINDOWS.BD])
							spawned_notes[col].remove_at(0)
				else:
					if _time-n.t > Global.windows[Global.WINDOWS.BD]:
						n.missed()
						handle_score(n, Global.windows[Global.WINDOWS.BD])
						spawned_notes[col].remove_at(0)

func handle_score(noteobj,t):
	var judge = -1
	for x in range(len(Global.windows)):
		if abs(t) < Global.windows[x] and judge == -1:
			judge = x
		
	match(judge):
		0: 
			osuScore += 320
			combo += 1
		1: 
			osuScore += 300
			combo += 1
		2: 
			osuScore += 200
			combo += 1
		3: 
			osuScore += 100
			combo = 0
		4: 
			osuScore += 50
			combo = 0
		-1: 
			osuScore += 0
			combo = 0
			
	if combo > 0 and combo % 100 == 0:
		Global.DoToastie()
		
	Global.score.update_score((osuScore*1000000.0)/float(osumScore))
		
	cScore += Global.wife3(t/float(usec), 1)
	mScore += 2
	
	var percent = cScore/mScore*100
	Global.acc.text = ("%.2f" % percent)+"%"
	
	Global.set_combo(combo)
	Global.DoJudge(judge, noteobj.c)
	Global.DoHitError(t)

func handle_hit(col):
	if Global.user_settings.hitsound:
		hitsound.play(0)
	var _time = Global.song_time()+Global.user_settings.note_global_offset
	if len(spawned_notes[col]) > 0:
		var n = spawned_notes[col][0]
		if n != null:
			if _time-n.t > -Global.windows[Global.WINDOWS.BD]:
				n.hit()
				handle_score(n, _time-n.t)
				if n.h != true:
					spawned_notes[col].remove_at(0)
				Global.add_nps_note(_time)

func handle_release(col):
	var _time = Global.song_time()+Global.user_settings.note_global_offset
	if len(spawned_notes[col]) > 0:
		var n = spawned_notes[col][0]
		if n != null:
			if n.h:
				if _time-n.t > -Global.windows[Global.WINDOWS.BD]:
					n.release()
				if _time-n.t2 > Global.windows[Global.WINDOWS.BD]-n.life*usec:
					n.completed()
					spawned_notes[col].remove_at(0)

func _input(event):
	if event.is_action_pressed("col_0"):
		handle_hit(0)
	if event.is_action_pressed("col_1"):
		handle_hit(1)
	if event.is_action_pressed("col_2"):
		handle_hit(2)
	if event.is_action_pressed("col_3"):
		handle_hit(3)
	
	if event.is_action_released("col_0"):
		handle_release(0)
	if event.is_action_released("col_1"):
		handle_release(1)
	if event.is_action_released("col_2"):
		handle_release(2)
	if event.is_action_released("col_3"):
		handle_release(3)

	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
