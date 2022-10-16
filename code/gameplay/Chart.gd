extends Node

class_name Chart

var column_count = 4
var audiofilename = ""
var audioleadin = 0
var bpm = -1
var scroll_vels = []
var max_score = 0
var clap_times = []
var columns = []
var duration = -1

var sv_lookup_start = 0

func load_chart(directory, file):

	duration = -1
	for x in range(column_count):
		columns.append(null)
	
	sv_lookup_start = 0
	scroll_vels = []
	max_score = 0
	parse_osu(directory, file)
	
	for x in range(1,len(scroll_vels)):
		scroll_vels[x].z = scroll_vels[x-1].z + scroll_vels[x-1].x*(scroll_vels[x].y-scroll_vels[x-1].y)

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
			max_score += 320
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
		if last_notes[x].t > duration:
			duration = last_notes[x].t
		if last_notes[x].h:
			if last_notes[x].t2 > duration:
				duration = last_notes[x].t2

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
