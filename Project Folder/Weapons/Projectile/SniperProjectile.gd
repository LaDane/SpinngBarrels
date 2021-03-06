extends KinematicBody2D

var direction
var velocity = Vector2()
var speed = 1000
var damage = 100
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
		if collision.get_collider().has_method("take_enemy_damage"):
			Globals.update_combo()
			collision.get_collider().take_enemy_damage(damage)
		elif collision.get_collider().has_method("take_damage"):
			collision.get_collider().take_damage(damage)
		else:
			Globals.combo_count = 0
		
		queue_free()
