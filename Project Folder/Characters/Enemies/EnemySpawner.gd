extends Position2D

export var active = false
export var spawn_interval = 5
export var zombie_spawn = true
export var hitman_spawn = false
export var shottyman_spawn = false
export var robot_spawn = false
export var grenademan_spawn = false
export var sniper_spawn = false

onready var Player = get_parent().get_parent().get_node("Player")
var min_spawn_distance = 600

var zombie_scene = preload("res://Characters/Enemies/Zombie.tscn")
var hitman_scene = preload("res://Characters/Enemies/Hitman.tscn")
var shottyman_scene = preload("res://Characters/Enemies/Shottyman.tscn")
var robot_scene = preload("res://Characters/Enemies/Robot.tscn")
var grenade_scene = preload("res://Characters/Enemies/Grenade.tscn")
var sniper_scene = preload("res://Characters/Enemies/Sniper.tscn")

func _ready():
	$Timer.wait_time = spawn_interval

func set_active():
	active = true
	$Timer.wait_time = spawn_interval
	$Timer.start()
	print(name, " ", active)	
	
func set_deactive():
	active = false
	$Timer.stop()

func _on_Timer_timeout():
	var distance_to_player = global_position.distance_to(Player.global_position)
	if distance_to_player > min_spawn_distance:
		if zombie_spawn:
			var zombie = zombie_scene.instance()
			zombie.position = position 
			get_parent().add_child(zombie)
		if hitman_spawn:
			var hitman = hitman_scene.instance()
			hitman.position = position
			get_parent().add_child(hitman)
		if shottyman_spawn:
			var shottyman = shottyman_scene.instance()
			shottyman.position = position 
			get_parent().add_child(shottyman)
		if robot_spawn:
			var robot = robot_scene.instance()
			robot.position = position 
			get_parent().add_child(robot)
		if grenademan_spawn:
			var grenademan = robot_scene.instance()
			grenademan.position = position 
			get_parent().add_child(grenademan)
		if sniper_spawn:
			var sniper = sniper_scene.instance()
			sniper.position = position 
			get_parent().add_child(sniper)
