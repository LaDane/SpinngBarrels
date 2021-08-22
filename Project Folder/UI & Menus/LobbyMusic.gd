extends AudioStreamPlayer

var in_game = false

func _on_LobbyMusic_finished():
	if not in_game:
		LobbyMusic.stream = load("res://Music/title Screen music loop.wav")
		LobbyMusic.play()
