extends KinematicBody2D

export var compass_controls = false
export var face_mouse_control = true

var speed = 200
var velocity = Vector2.ZERO
var gun_position

var projectile = preload("res://Weapons/Projectile/Projectile.tscn")

func _ready():
	gun_position = get_node("GunPosition")

func get_input():
	velocity = Vector2.ZERO
	
	if face_mouse_control:
		if Input.is_action_pressed("W"):
			velocity += transform.x
		if Input.is_action_pressed("S"):
			velocity -= transform.x
		if Input.is_action_pressed("A"):
			velocity += transform.y
		if Input.is_action_pressed("D"):
			velocity -= transform.y
	
	if compass_controls:
		if Input.is_action_pressed("W"):
			velocity.y -= 1
		if Input.is_action_pressed("S"):
			velocity.y += 1
		if Input.is_action_pressed("A"):
			velocity.x -= 1
		if Input.is_action_pressed("D"):
			velocity.x += 1
			
		velocity = velocity.normalized() * speed


func fire_weapon():
	var projectile_object = projectile.instance()
	projectile_object.start($GunPosition.global_position, rotation)
	get_parent().add_child(projectile_object)


func _physics_process(delta):
	look_at(get_global_mouse_position())
	get_input()
	
	if face_mouse_control:
		velocity = move_and_slide(velocity * speed)
	if compass_controls:
		velocity = move_and_slide(velocity)
		
	if Input.is_action_just_pressed("shoot"):
		fire_weapon()
