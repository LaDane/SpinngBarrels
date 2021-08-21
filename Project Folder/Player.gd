extends KinematicBody2D

export var compass_controls = false
export var face_mouse_control = true

export var health = 100
var is_dead = false
var movement_speed = 225
var velocity = Vector2.ZERO

var gun_rotation = ["assault", "laser", "pistol", "rocket_launcher", "shotgun", "smg", "sniper"]
var current_gun_rotation = 0

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
var assault_sfx_fire = preload("res://SFX/SFX_guns/Assault rifle fire.wav")
var laser_sfx_fire = preload("res://SFX/SFX_guns/Laser charge + dischrage.wav")
var pistol_sfx_fire = preload("res://SFX/SFX_guns/Kenney gun sound export Pistol Fire.wav")
var rocket_launcher_sfx_fire = preload("res://SFX/SFX_guns/Kenney gun sound export Rocket fire.wav")
var shotgun_sfx_fire = preload("res://SFX/SFX_guns/Kenney gun sound export Shotgun fire.wav")
var smg_sfx_fire = preload("res://SFX/SFX_guns/Kenney gun sound export SMG fire.wav")
var sniper_sfx_fire = preload("res://SFX/SFX_guns/Kenney gun sound export Sniper Fire.wav")

# Gun projectils
#var projectile = preload("res://Weapons/Projectile/Projectile.tscn")
var assault_projectile_scene = preload("res://Weapons/Projectile/AssaultProjectile.tscn")
var laser_projectile_scene = preload("res://Weapons/Projectile/LaserProjectile.tscn")
var pistol_projectile_scene = preload("res://Weapons/Projectile/PistolProjetile.tscn")
var rocket_launcher_projectile_scene = preload("res://Weapons/Projectile/RocketProjectile.tscn")
var sniper_projectile_scene = preload("res://Weapons/Projectile/SniperProjectile.tscn")
var current_projectile_scene

# Gun fire interval
var weapon_firing = false
var use_spread = false
var shots_in_mag = 1
var shots_fired = 0

# Assault gun values
var assault_shots_in_mag = 3
var assault_fire_interval = 0.17

# SMG gun values
var smg_shots_in_mag = 10
var smg_fire_interval = 0.08

# Shotgun gun values
var shotgun_shots_in_mag = 5
var shotgun_fire_interval = 0.01

const scent_scene = preload("res://Characters/Player/Scent.tscn")
var scent_trail = []


func _ready():
	$ScentTimer.connect("timeout", self, "add_scent")
	
	randomize()
	gun_rotation.shuffle()
	change_weapon(gun_rotation[current_gun_rotation])


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
		if Input.is_action_just_pressed("shoot") and !weapon_firing:
			fire_weapon()
			weapon_firing = true


func fire_weapon():
	use_spread = false
	shots_in_mag = 1
	$GunTimer.wait_time = 0
	
	if current_gun == "assault":
		$AudioAssualt.play(1.0)
		current_projectile_scene = assault_projectile_scene
		shots_in_mag = assault_shots_in_mag
		$GunTimer.wait_time = assault_fire_interval
		
	elif current_gun == "laser":
		$AudioLaser.play(2.79)
		current_projectile_scene = laser_projectile_scene
		
	elif current_gun == "pistol":
		$AudioPistol.play(0.95)
		current_projectile_scene = pistol_projectile_scene
		
	elif current_gun == "rocket_launcher":
		$AudioRocketLauncher.play(0.98)
		current_projectile_scene = rocket_launcher_projectile_scene
		
	elif current_gun == "shotgun":
		$AudioShotgun.play(1.0)
		current_projectile_scene = pistol_projectile_scene
		shots_in_mag = shotgun_shots_in_mag
		$GunTimer.wait_time = shotgun_fire_interval
		use_spread = true
		
	elif current_gun == "smg":
		$AudioSMG.play(1.0)
		current_projectile_scene = pistol_projectile_scene
		shots_in_mag = smg_shots_in_mag
		$GunTimer.wait_time = smg_fire_interval
		use_spread = true
		
	elif current_gun == "sniper":
		$AudioSniper.play(0.98)
		current_projectile_scene = sniper_projectile_scene
		
	spawn_projectile()


func spawn_projectile():
	var current_projectile = current_projectile_scene.instance()
	current_projectile.start($Gun/GunPosition.global_position, rotation, use_spread)
	get_parent().add_child(current_projectile)
	
	shots_fired = shots_fired + 1
	if shots_fired >= shots_in_mag:
		$ChangeWeaponTimer.start()
	else:
		$GunTimer.start()


func _on_ChangeWeaponTimer_timeout():
	next_gun_in_rotation()


func _on_GunTimer_timeout():
	spawn_projectile()


func next_gun_in_rotation():
	current_gun_rotation = current_gun_rotation + 1
	if current_gun_rotation >= gun_rotation.size():
		current_gun_rotation = 0
	change_weapon(gun_rotation[current_gun_rotation])
	weapon_firing = false


func change_weapon(selected_gun):
	remove_weapon()
	current_gun = selected_gun
	shots_fired = 0
	
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







