extends Popup


func _ready():
	$NinePatchRect/VBoxContainer/MasterSlider.value = Globals.master_volume
	$NinePatchRect/VBoxContainer/MusicSlider.value = Globals.music_volume
	$NinePatchRect/VBoxContainer/SoundEffectsSlider.value = Globals.SFX_volume


func _input(event):
	if Input.is_action_just_pressed("pause"):
		if not visible:
			open_popup()
		else:
			close_popup()


func open_popup():
	popup_centered()
	get_tree().paused = true
	$Music.play()


func close_popup():
	visible = false
	get_tree().paused = false
	$Music.stop()


func display_popup():
	popup()


func _on_MasterSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	Globals.master_volume = value


func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	Globals.music_volume = value


func _on_SoundEffectsSlider_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	Globals.SFX_volume = value


func _on_FullScreenButton_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_ParticlesButton_pressed():
	close_popup()


func _on_BackButton_pressed():
	$Music.stop()
	get_tree().paused = false
	visible = false


func _on_Button_pressed():
	get_tree().change_scene("res://UI & Menus/Main Menu.tscn")
	get_tree().paused = false
