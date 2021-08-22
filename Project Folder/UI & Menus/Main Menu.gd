extends Control


func _ready():
	if not LobbyMusic.playing:
		LobbyMusic.playing = true


func _on_PlayGame_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")


func _on_Options_pressed():
	get_tree().change_scene("res://UI & Menus/Options.tscn")


func _on_Credits_pressed():
	pass # Replace with function body.


func _on_Exit_Game_pressed():
	get_tree().quit()
