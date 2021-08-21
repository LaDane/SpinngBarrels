extends KinematicBody2D

var direction
var velocity = Vector2()
var speed = 600
#var on_ready = false

func start(pos, dir):
	rotation = dir
	global_position = pos 
	velocity = Vector2(speed, 0).rotated(rotation)


func _ready():
	yield(get_tree(), "idle_frame")
	print($AnimatedSprite.animation)
	$AnimatedSprite.play("flash")
	
	
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("collision")
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	print("destroyed")
	queue_free()

