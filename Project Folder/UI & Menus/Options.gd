extends Control


func _on_MasterSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	Globals.master_volume = value


func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	Globals.master_volume = value


func _on_SoundEffectsSlider_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	Globals.master_volume = value


func _on_FullScreenButton_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_ParticlesButton_pressed():
	pass # Replace with function body.


func _on_BackButton_pressed():
		get_tree().change_scene("res://UI & Menus/Main Menu.tscn")
