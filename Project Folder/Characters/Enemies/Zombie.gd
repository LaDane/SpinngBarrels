extends KinematicBody2D

onready var Playerpos = get_node("../Player")
export var speed = 200
var motion = Vector2()
onready var path_to_destination
onready var player_position = Playerpos.get_global_position()
onready var map_navigation = get_parent().get_node("Navigation2D")
onready var destination = map_navigation.get_closest_point(player_position)


const UP = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	movement()

func movement():
	var direction = (Playerpos.position - position).normalized()
	motion = direction * speed
	look_at(Playerpos.global_position)
	move_and_slide(motion, UP, false)

