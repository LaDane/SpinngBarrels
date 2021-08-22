extends CanvasLayer

var floaty_text_scene = preload("res://UI & Menus/FloatingText.tscn")

func _process(delta):
	$VBoxContainer3/Label.text = "Combo: " + String(Globals.combo_count)

	
func display_combo(combo):
	if Globals.combo_count > 2:
		var floaty_text = floaty_text_scene.instance()
		
		randomize();
		floaty_text.position = Vector2(rand_range(500, 1000), rand_range(300, 600))
		floaty_text.velocity = Vector2(rand_range(-50, 50), -100)
		floaty_text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)	

		floaty_text.set_text("Combo: " + String(Globals.combo_count))
		
		add_child(floaty_text)
