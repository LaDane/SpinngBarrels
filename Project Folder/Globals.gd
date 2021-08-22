extends Node


var camera = null
#var transitioner : Transitioner = null

var combo_count = 0
var on_streak = false


func update_combo():
	Globals.combo_count = Globals.combo_count + 1
	get_tree().call_group("Interface", "display_combo", Globals.combo_count)
	get_tree().call_group("Player", "combo_heal")
