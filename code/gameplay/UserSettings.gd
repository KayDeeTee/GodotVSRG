extends Node
class_name UserSettings

var reverse_scroll = false #inverts scroll direction
var scroll_speed = 1.575 #sets base scroll speed
var cmod = true #disables scroll vels

var toasties = true #enables/disables toasties
var nps = true #enables/disables the nps graph

#claps are played automatically when the note should have been hit
#hitsounds are played when you press a key

#claps are better for actually hitting accurately, they work as a per note metronome
#hitsounds are better for "feel"

var clap = true #enabled/disables clap sound
var hitsound = false #enabled/disables hitsounds

#these are inverted if reverse scroll is enabled
var hidden_start_y = .45 #for fade out
var hidden_end_y = .5 #for fade out
var sudden_start_y = 0 #for fade in
var sudden_end_y = 0 #for fade in

var note_global_offset = 0 #offset for hitting notes ////// if you're hitting early(negative) make this positive
var note_visual_offset = 0 #offset for rendering notes  ////// if you're hitting early(negative) make this positive too?

var immediate_fail = false

func load_settings():
	pass
