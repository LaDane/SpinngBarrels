extends KinematicBody2D

var direction
var velocity = Vector2()
var speed = 600
var rocket_whistle_sfx = preload("res://SFX/SFX_guns/Kenney gun sound export Rocket Whistle.wav")
var explosion_scene = preload("res://Weapons/Projectile/RocketExplosion.tscn")
var damage = 20

func start(pos, dir, spread):
	if spread:
		randomize()
		var spread_range = rand_range(-0.2, 0.2)
		dir = dir + spread_range
		
	rotation = dir
	global_position = pos 
	velocity = Vector2(speed, 0).rotated(rotation)
	$Audio.play(1.0)


func _ready():
	yield(get_tree(), "idle_frame")
	$AnimatedSprite.play("flash")
	
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("take_enemy_damage"):
			Globals.combo_count = Globals.combo_count + 1
			collision.get_collider().take_enemy_damage(damage)
		elif collision.get_collider().has_method("take_damage"):
			collision.get_collider().take_damage(damage)
		else:
			Globals.combo_count = 0
		
		var explosion_object = explosion_scene.instance()
		get_parent().add_child(explosion_object)
		explosion_object.position = $ExplosionPoint.global_position 
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
#	queue_free()
	pass

