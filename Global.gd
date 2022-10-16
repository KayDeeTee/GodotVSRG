extends Node

var judge
var composer
var hiterror
var combo
var progressbar
var acc
var counts
var avg
var score
var title
var receptor_con
var nps
var toastie

var user_settings = UserSettings.new()

var break_spr = [null,null,null,null]

var jCount = [0,0,0,0,0,0]
var total_notes = 0
var current_mean = 0

var colors = [Color("#8aebf1"),Color("#f4b41b"),Color("#b6d53c"),Color("#3978a8"),Color("#8e478c"),Color("#e6482e")]
var windows = [22500, 45000, 90000, 135000, 180000]
enum WINDOWS{
	MA = 0,
	PF = 1,
	GR = 2,
	GD = 3,
	BD = 4
}

var cached_sv_time = -1
var cached_sv_at = -1

var HOLD_LIFE = .5

func set_title(t):
	title.update_title(t)

func set_combo(c):
	combo.update_combo(c)

func get_sv_time(t):
	if user_settings.cmod:
		return t*user_settings.scroll_speed
	return composer.get_adjusted_time(t)*user_settings.scroll_speed

func get_song_sv_time():
	if user_settings.cmod:
		return song_time()*user_settings.scroll_speed
	if cached_sv_at != Time.get_ticks_usec():
		cached_sv_at = Time.get_ticks_usec()
		cached_sv_time = composer.get_adjusted_time(song_time(), true)*user_settings.scroll_speed
	return cached_sv_time

func song_time():
	return Time.get_ticks_usec()-composer.t_song_zero+composer.t_delay

func window_from_offset(offset):
	for x in range(len(windows)):
		if abs(offset) < windows[x]:
			return x
	return 5

func SetProgress(percent):
	progressbar.SetProgress(percent)

func add_nps_note(t):
	if !user_settings.nps:
		return
	nps.add_note(t)

func DoToastie():
	if !user_settings.toasties:
		return
	toastie.fade_in = 0

func DoHitError(t):	
	hiterror.add_pixel(colors[window_from_offset(t)], t/1000)
	#calc average
	if t != 180000:
		current_mean -= current_mean/((total_notes+1)*1.0)
		current_mean += t/((total_notes+1)*1000.0)
		total_notes += 1
		avg.text = "[center]%.1fms[/center]" % [current_mean]

func DoJudge(j, column):
	if j == -1:
		j = 5
	judge.judge(j)
	
	jCount[j] += 1
	counts.text = ""
	for c in jCount:
		counts.text += str(c)
		counts.text += "\n"
		
	if j >= 3:
		break_spr[column].self_modulate = colors[j]


var wife3_mine_hit_weight = -7.0
var wife3_hold_drop_weight = -4.5
var wife3_miss_weight = -5.5	
func wife3(maxms, ts):
	var j_pow = 0.75
	var maxpoints = 2
	var ridic = 5*ts
	var max_boo_weight = 180*ts
	maxms = abs(maxms*1000)
	#print(maxms)
	if maxms < ridic:
		return maxpoints
	
	var zero = 65* pow(ts, j_pow)
	var dev = 22.7 * pow(ts, j_pow)
	
	if maxms <= zero:
		return maxpoints * werwerwerwerf((zero - maxms) / dev)
	if maxms <= max_boo_weight:
		return (maxms-zero) * wife3_miss_weight / (max_boo_weight - zero)
	return wife3_miss_weight
	
func werwerwerwerf(x):
	var a1 = 0.254829592
	var a2 = -0.284496736
	var a3 = 1.421413741
	var a4 = -1.453152027
	var a5 = 1.061405429
	var p = 0.3275911

	var s = sign(x)
	x = abs(x);

	var t = 1 / (1 + p * x);
	var y = 1 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x);

	return s * y;

