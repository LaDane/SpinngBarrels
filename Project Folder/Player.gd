extends KinematicBody2D

export var compass_controls = false
export var face_mouse_control = true

var health = 100
var movement_speed = 200
var velocity = Vector2.ZERO

var projectile = preload("res://Weapons/Projectile/Projectile.tscn")

func _ready():
	pass


func _physics_process(delta):
	look_at(get_global_mouse_position())
	get_input()
	
	if face_mouse_control:
		velocity = move_and_slide(velocity * movement_speed)
	if compass_controls:
		velocity = move_and_slide(velocity)
		
	if Input.is_action_just_pressed("shoot"):
		fire_weapon()


func get_input():
	velocity = Vector2.ZERO
	
	if face_mouse_control:
		if Input.is_action_pressed("W"):
			velocity += transform.x
		if Input.is_action_pressed("S"):
			velocity -= transform.x
		if Input.is_action_pressed("A"):
			velocity -= transform.y
		if Input.is_action_pressed("D"):
			velocity += transform.y
	
	if compass_controls:
		if Input.is_action_pressed("W"):
			velocity.y -= 1
		if Input.is_action_pressed("S"):
			velocity.y += 1
		if Input.is_action_pressed("A"):
			velocity.x -= 1
		if Input.is_action_pressed("D"):
			velocity.x += 1
			
		velocity = velocity.normalized() * movement_speed
	
	# Walking Animation
	if velocity != Vector2.ZERO and !$AnimatedSprite.is_playing():
		$AnimatedSprite.play("walk")
	elif velocity == Vector2.ZERO and $AnimatedSprite.is_playing():
		$AnimatedSprite.frame = 0
		$AnimatedSprite.stop()
		



func fire_weapon():
	var projectile_object = projectile.instance()
	projectile_object.start($GunPosition.global_position, rotation)
	get_parent().add_child(projectile_object)


func take_damage(dmg):
	health = health - dmg
		
	if health <= 0:
		player_die()

func player_die():
	print("You have died")

