extends Node


var camera = null
#var transitioner : Transitioner = null

var combo_count = 0
var on_streak = false

var master_volume = -5
var SFX_volume = -5
var music_volume = -5


func _ready():
	AudioServer.set_bus_volume_db(0, Globals.master_volume)
	AudioServer.set_bus_volume_db(1, Globals.SFX_volume)
	AudioServer.set_bus_volume_db(2, Globals.music_volume)


func update_combo():
	Globals.combo_count = Globals.combo_count + 1
	get_tree().call_group("Interface", "display_combo", Globals.combo_count)
	get_tree().call_group("Player", "combo_heal")
