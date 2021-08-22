extends Node2D
var current_room = 0
onready var RoomTimer = $Rooms/RoomTimer

# Start area
var zombie_spawn_start_area1
var zombie_spawn_start_area2
var shottyman_spawn_start_area1

# Room 1
var zombie_spawn_room1_1
var zombie_spawn_room1_2
var hitman_spawn_room1_1
var hitman_spawn_room1_2
var shottyman_spawn_room1_1

# Corridor 1
var zombie_spawn_corrider1_1

# Room 2
var zombie_spawn_room2_1

func _ready():
	# Getting spawners
	# Starting area
	zombie_spawn_start_area1 = $Enemies/ZombieSpawn_StartArea1
	zombie_spawn_start_area2 = $Enemies/ZombieSpawn_StartArea2
	shottyman_spawn_start_area1 = $Enemies/ShottymanSpawn_StartArea1
	zombie_spawn_start_area1.set_active()
	zombie_spawn_start_area2.set_active()
	shottyman_spawn_start_area1.set_active()
	
	# Room 1
	zombie_spawn_room1_1 = $Enemies/ZombieSpawn_Room1_1
	zombie_spawn_room1_2 = $Enemies/ZombieSpawn_Room1_2
	hitman_spawn_room1_1 = $Enemies/HitmanSpawn_Room1_1
	hitman_spawn_room1_2 = $Enemies/HitmanSpawn_Room1_2
	shottyman_spawn_room1_1 = $Enemies/ShottymanSpawn_Room1_1

	# Corrider 1
	zombie_spawn_corrider1_1 = $Enemies/ZombieSpawn_Corridor1_1
	
	# Room 2
	zombie_spawn_room2_1 = $Enemies/ZombieSpawn_Room2_1

func _on_Room_1_body_entered(body):
	if current_room < 1:
		RoomTimer.wait_time = 120
		RoomTimer.start()
		current_room = 1
	active_room_1()
	
func active_room_1():
	zombie_spawn_start_area1.set_deactive()
	zombie_spawn_start_area2.set_deactive()
	shottyman_spawn_start_area1.set_deactive()
	
	zombie_spawn_room1_1.set_active()
	zombie_spawn_room1_2.set_active()
	hitman_spawn_room1_1.set_active()
	hitman_spawn_room1_2.set_active()
	shottyman_spawn_room1_1.set_active()


func _on_RoomTimer_timeout():
	if current_room == 1:
		$Rooms/Doors/Door2/AnimationPlayer.play("Unlock")
		zombie_spawn_corrider1_1.set_active()


func _on_Room_2_body_entered(body):
	current_room = 2
	active_room_2()
	
func active_room_2():
	zombie_spawn_room1_1.set_deactive()
	zombie_spawn_room1_2.set_deactive()
	hitman_spawn_room1_1.set_deactive()
	hitman_spawn_room1_2.set_deactive()
	shottyman_spawn_room1_1.set_deactive()
	
	zombie_spawn_room2_1.set_active()
