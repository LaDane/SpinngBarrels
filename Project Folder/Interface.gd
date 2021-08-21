extends CanvasLayer


func _process(delta):
	$VBoxContainer3/Label.text = "Combo: " + String(Globals.combo_count)
