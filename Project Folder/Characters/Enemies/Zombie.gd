extends "res://Characters/Enemies/EnemyBaseScript.gd"


func _ready():
	speed = 70
	health = 100
	attack_damage = 34
	reload_time = 2
	
	set_reload_time(reload_time)


func _physics_process(delta):
	move_with_collision()


func move_with_collision():
	motion = move_and_slide(motion, Vector2(0,0))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision and collision.collider.has_method("take_damage") and weapon_ready:
			print("Ouch!")
			collision.collider.take_damage(attack_damage)
			weapon_ready = false
			$ReloadTime.wait_time = reload_time
			$ReloadTime.start()




### ALTERNATE PATHFINDING ALGORITHM

#extends KinematicBody2D
#
#export var SPEED = 100
#var velocity: Vector2 = Vector2.ZERO
#
#var path: Array = []	# Contains destination positions
#var levelNavigation: Navigation2D = null
#var player = null
#var player_spotted: bool = false
#
#onready var line2d = $Line2D
#
#
#func _ready():
#	yield(get_tree(), "idle_frame")
#	var tree = get_tree()
#	if tree.has_group("LevelNavigation"):
#		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
#	if tree.has_group("Player"):
#		player = tree.get_nodes_in_group("Player")[0]
#
#	$Timer.wait_time = rand_range(0.2, 0.3)
#
#func _physics_process(delta):
#	line2d.global_position = Vector2.ZERO
#	if player:
#		look_at(player.global_position)
#		navigate()
#	move()
#
#
#func navigate():	# Define the next position to go to
#	if path.size() > 1:
#		velocity = global_position.direction_to(path[1]) * SPEED
#
#		# If reached the destination, remove this point from path array
#		if global_position == path[0]:
#			path.pop_front()
#
#
#func generate_path():	# It's obvious
#	if levelNavigation != null and player != null:
#		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
#		line2d.points = path
#
#func move():
#	velocity = move_and_slide(velocity, Vector2(0,0))
#
#
#func _on_Timer_timeout():
#	generate_path()


