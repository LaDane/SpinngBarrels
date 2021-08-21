extends KinematicBody2D

onready var Player = get_parent().get_parent().get_node("Player")
export var speed = 200
var motion = Vector2()
onready var path_to_destination
onready var player_position = Player.get_global_position()
onready var map_navigation = get_parent().get_parent().get_node("Navigation2D")
onready var destination = map_navigation.get_closest_point(player_position)


const UP = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	movement()
	generate_path()

func movement():
	var direction = (Player.position - position).normalized()
	motion = direction * speed
	look_at(Player.global_position)
	move_and_slide(motion, UP, false)


func generate_path():
	var path = map_navigation.get_simple_path(position, Player.position)
	path = path 
