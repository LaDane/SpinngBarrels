extends Node2D
var current_room = 0
onready var RoomTimer = $Rooms/RoomTimer

func _on_Room_1_body_entered(body):
	if current_room < 1:
		RoomTimer.wait_time = 120
		RoomTimer.start()
		current_room = 1

func _on_RoomTimer_timeout():
	if current_room == 1:
		$Rooms/Doors/Door2/AnimationPlayer.play("Unlock")
