extends KinematicBody2D

var direction
var velocity = Vector2()
var speed = 600
#var on_ready = false

func start(pos, dir, spread):
	if spread:
		randomize()
		var spread_range = rand_range(-0.2, 0.2)
		dir = dir + spread_range
		
	rotation = dir
	global_position = pos 
	velocity = Vector2(speed, 0).rotated(rotation)


func _ready():
	yield(get_tree(), "idle_frame")
	$AnimatedSprite.play("flash")
	
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.has_method("take_enemy_damage"):
			pass
		elif collision.has_method("take_damage"):
			pass
		
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

