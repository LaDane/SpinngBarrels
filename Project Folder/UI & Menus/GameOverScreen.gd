extends Control


func _on_TryAgain_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")


func _on_MainMenu_pressed():
	get_tree().change_scene("res://UI & Menus/Main Menu.tscn")
