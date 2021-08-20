extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction
var velocity = Vector2()
var speed = 500

func start(pos, dir):
	rotation = dir
	global_position = pos 
	velocity = Vector2(speed, 0).rotated(rotation)

#func _ready():
#	look_at(get_global_mouse_position())
#	direction = (get_global_mouse_position() - global_position).normalized()
#	velocity = position.direction_to(get_global_mouse_position()) * 10
	
func _physics_process(delta):
#	move_and_collide(direction * speed * delta)
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("collision")

func _on_VisibilityNotifier2D_screen_exited():
	print("destroyed")
	queue_free()

