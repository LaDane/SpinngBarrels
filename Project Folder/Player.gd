extends KinematicBody2D

export var compass_controls = false
export var face_mouse_control = true

var health = 100
var is_dead = false
var movement_speed = 200
var velocity = Vector2.ZERO

# Gun scenes
var assault_scene = preload("res://Weapons/WeaponScenes/Assault.tscn")
var laser_scene = preload("res://Weapons/WeaponScenes/Laser.tscn")
var pistol_scene = preload("res://Weapons/WeaponScenes/Pistol.tscn")
var rocket_launcher_scene = preload("res://Weapons/WeaponScenes/RocketLauncher.tscn")
var shotgun_scene = preload("res://Weapons/WeaponScenes/Shotgun.tscn")
var smg_scene = preload("res://Weapons/WeaponScenes/SMG.tscn")
var sniper_scene = preload("res://Weapons/WeaponScenes/Sniper.tscn")
var current_gun = ""

# Gun sounds
var assualt_sfx_fire = preload("res://SFX/SFX_guns/Assault rifle fire.wav")
var laser_sfx_fire = preload("res://SFX/SFX_guns/Laser charge + dischrage.wav")
var pistol_sfx_fire = preload("res://SFX/SFX_guns/Kenney gun sound export Pistol Fire.wav")
var rocket_launcher_sfx_fire = preload("res://SFX/SFX_guns/Kenney gun sound export Rocket fire.wav")
var shotgun_sfx_fire = preload("res://SFX/SFX_guns/Kenney gun sound export Shotgun fire.wav")
var smg_sfx_fire = preload("res://SFX/SFX_guns/Kenney gun sound export SMG fire.wav")
var sniper_sfx_fire = preload("res://SFX/SFX_guns/Kenney gun sound export Sniper Fire.wav")

# Gun projectils
var projectile = preload("res://Weapons/Projectile/Projectile.tscn")

const scent_scene = preload("res://Characters/Player/Scent.tscn")
var scent_trail = []


func _ready():
	$ScentTimer.connect("timeout", self, "add_scent")
	change_weapon("pistol")


func add_scent():
	var scent = scent_scene.instance()
	scent.player = self
	scent.position = self.position
	
#	Game.level.effects.
	get_parent().add_child(scent)
	scent_trail.push_front(scent)
	


func _physics_process(delta):
	get_input()


func get_input():
	velocity = Vector2.ZERO
	if !is_dead:
		look_at(get_global_mouse_position())	
		if face_mouse_control:
			if Input.is_action_pressed("W"):
				velocity += transform.x
			if Input.is_action_pressed("S"):
				velocity -= transform.x
			if Input.is_action_pressed("A"):
				velocity -= transform.y
			if Input.is_action_pressed("D"):
				velocity += transform.y
			velocity = move_and_slide(velocity * movement_speed)
		
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
			velocity = move_and_slide(velocity)
	
	# Walking Animation
	if velocity != Vector2.ZERO and !$AnimatedSprite.is_playing():
		$AnimatedSprite.play("walk")
	elif velocity == Vector2.ZERO and $AnimatedSprite.is_playing() and !is_dead:
		$AnimatedSprite.frame = 0
		$AnimatedSprite.stop()
	
	# Fire weapon
	if Input.is_action_just_pressed("shoot"):
		fire_weapon()
	
	# Temporary change weapon
	if Input.is_action_just_pressed("1"):
		change_weapon("assault")
	if Input.is_action_just_pressed("2"):
		change_weapon("laser")
	if Input.is_action_just_pressed("3"):
		change_weapon("pistol")
	if Input.is_action_just_pressed("4"):
		change_weapon("rocket_launcher")
	if Input.is_action_just_pressed("5"):
		change_weapon("shotgun")
	if Input.is_action_just_pressed("6"):
		change_weapon("smg")
	if Input.is_action_just_pressed("7"):
		change_weapon("sniper")
	

func change_weapon(selected_gun):
	remove_weapon()
	current_gun = selected_gun
	
	var selected_scene
	if current_gun == "assault":
		selected_scene = assault_scene
	elif current_gun == "laser":
		selected_scene = laser_scene
	elif current_gun == "pistol":
		selected_scene = pistol_scene
	elif current_gun == "rocket_launcher":
		selected_scene = rocket_launcher_scene
	elif current_gun == "shotgun":
		selected_scene = shotgun_scene
	elif current_gun == "smg":
		selected_scene = smg_scene
	elif current_gun == "sniper":
		selected_scene = sniper_scene
	
	var gun_object = selected_scene.instance()
	gun_object.position = $Arm.position
	add_child(gun_object)


func remove_weapon():
	if $Gun:
		remove_child($Gun)					# Maybe memory intensive

func fire_weapon():
	var projectile_object = projectile.instance()
	projectile_object.start($Gun/GunPosition.global_position, rotation)
	get_parent().add_child(projectile_object)
	
	if current_gun == "assault":
		$AudioAssualt.play()
	elif current_gun == "laser":
		$AudioLaser.play()
	elif current_gun == "pistol":
		$AudioPistol.play()
	elif current_gun == "rocket_launcher":
		$AudioRocketLauncher.play()
	elif current_gun == "shotgun":
		$AudioShotgun.play()
	elif current_gun == "smg":
		$AudioSMG.play()
	elif current_gun == "sniper":
		$AudioSniper.play()


func take_damage(dmg):
	health = health - dmg
	if health <= 0 and is_dead == false:
		player_die()


func player_die():
	is_dead = true
	remove_weapon()
	
	if $AnimatedSprite.is_playing():
		$AnimatedSprite.stop()
		
	$AnimatedSprite.play("dead")
	print("You have died")

