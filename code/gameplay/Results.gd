extends Node

class_name Results

class HitInfo:
	var time
	var offset
	var type #HIT/OK/NG (OK/NG are used for holds)
		
enum HitInfoType{
	HIT,
	MISS,
	OK,
	NO_GOOD
}

var hits #list of hitinfo
var failed #did you fail at any point during the song
var song_start
var song_end
var title
var artist

func _init():
	hits = []
	failed = false
	
func reset():
	hits.clear()
	failed = false
	
func add_hit(time, offset, missed=false,hold_release=false):
	var hit_info = HitInfo.new()
	hit_info.time = time
	hit_info.offset = offset
	if !missed:
		hit_info.type = HitInfoType.HIT if !hold_release else HitInfoType.OK
	else:
		hit_info.type = HitInfoType.MISS if !hold_release else HitInfoType.NO_GOOD
	hits.append(hit_info)
	
func on_fail():
	failed = true
		
