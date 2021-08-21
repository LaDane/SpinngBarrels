extends KinematicBody2D

var direction
var velocity = Vector2()
var speed = 500
#var on_ready = false

func start(pos, dir, use_spread):
	rotation = dir
	global_position = pos 
	velocity = Vector2(speed, 0).rotated(rotation)


func _ready():
	yield(get_tree(), "idle_frame")
	$AnimatedSprite.play("flash")
	
	
func _physics_process(delta):
	$Sprite.scale.x = $Sprite.scale.x + 0.1
	$CollisionShape2D.scale.x = $Sprite.scale.x
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.has_method("take_enemy_damage"):
			pass
		elif collision.has_method("take_damage"):
			pass
		else:
			queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

