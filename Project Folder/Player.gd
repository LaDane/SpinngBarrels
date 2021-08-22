extends KinematicBody2D

export var compass_controls = false
export var face_mouse_control = true

export var health = 200
export var max_health = 200
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

# Gun sprites
var assault_sprite
var laser_sprite
var pistol_sprite
var rocket_sprite
var shotgun_sprite
var smg_sprite
var sniper_sprite

# Weapon wheel
var weapon_wheel_sprite
var weapon_wheel_positions
var visible_wheel_positions = [4, 5, 0, 1, 2]

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

# Particles
var show_bullet_shells = false
var bullet_shells_scene = preload("res://Particles/Bullet Particles.tscn")

const scent_scene = preload("res://Characters/Player/Scent.tscn")
var scent_trail = []

var invincible = false


func _ready():
	$ScentTimer.connect("timeout", self, "add_scent")
	$Camera2D/Interface/VBoxContainer2/ProgressBar.max_value = max_health
	$Camera2D/Interface/VBoxContainer2/ProgressBar.value = health
	
	randomize()
	gun_rotation.shuffle()
	change_weapon(gun_rotation[current_gun_rotation])
	
	# Weapon wheel assign shit
	assault_sprite = $Camera2D/Interface/assault
	laser_sprite = $Camera2D/Interface/laser
	pistol_sprite = $Camera2D/Interface/pistol
	rocket_sprite = $Camera2D/Interface/rocket
	shotgun_sprite = $Camera2D/Interface/shotgun
	smg_sprite = $Camera2D/Interface/smg
	sniper_sprite = $Camera2D/Interface/sniper
	
	var pos0 = $Camera2D/Interface/VBoxContainer/WeaponWheel/Pos0
	var pos1 = $Camera2D/Interface/VBoxContainer/WeaponWheel/Pos1
	var pos2 = $Camera2D/Interface/VBoxContainer/WeaponWheel/Pos2
	var pos3 = $Camera2D/Interface/VBoxContainer/WeaponWheel/Pos3
	var pos4 = $Camera2D/Interface/VBoxContainer/WeaponWheel/Pos4
	var pos5 = $Camera2D/Interface/VBoxContainer/WeaponWheel/Pos5
	
	weapon_wheel_positions = [pos0, pos1, pos2, pos3, pos4, pos5]
	weapon_wheel_sprite = $Camera2D/Interface/VBoxContainer/WeaponWheel


func add_scent():
	var scent = scent_scene.instance()
	scent.player = self
	scent.position = self.position
	
#	Game.level.effects.
	get_parent().add_child(scent)
	scent_trail.push_front(scent)
	


func _physics_process(delta):
	get_input()
	weapon_wheel_follow_pos()


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
	show_bullet_shells = false
	shots_in_mag = 1
	$GunTimer.wait_time = 0
	
	if current_gun == "assault":
		$AudioAssualt.play(1.0)
		current_projectile_scene = assault_projectile_scene
		shots_in_mag = assault_shots_in_mag
		$GunTimer.wait_time = assault_fire_interval
		Globals.camera.shake(75, 0.5, 75)
		show_bullet_shells = true
		
	elif current_gun == "laser":
		$AudioLaser.play(2.79)
		current_projectile_scene = laser_projectile_scene
		
	elif current_gun == "pistol":
		$AudioPistol.play(0.95)
		current_projectile_scene = pistol_projectile_scene
		Globals.camera.shake(40, 0.5, 15)
		show_bullet_shells = true
		
	elif current_gun == "rocket_launcher":
		$AudioRocketLauncher.play(0.98)
		current_projectile_scene = rocket_launcher_projectile_scene
		Globals.camera.shake(300, 0.5, 300)
		
	elif current_gun == "shotgun":
		$AudioShotgun.play(1.0)
		current_projectile_scene = pistol_projectile_scene
		shots_in_mag = shotgun_shots_in_mag
		$GunTimer.wait_time = shotgun_fire_interval
		use_spread = true
		Globals.camera.shake(100, 0.5, 100)
		show_bullet_shells = true
		
	elif current_gun == "smg":
		$AudioSMG.play(1.0)
		current_projectile_scene = pistol_projectile_scene
		shots_in_mag = smg_shots_in_mag
		$GunTimer.wait_time = smg_fire_interval
		use_spread = true
		Globals.camera.shake(75, 1, 75)
		show_bullet_shells = true
		
	elif current_gun == "sniper":
		$AudioSniper.play(0.98)
		current_projectile_scene = sniper_projectile_scene
		Globals.camera.shake(300, 0.5, 300)
		show_bullet_shells = true
		
	spawn_projectile()


func spawn_projectile():
	var current_projectile = current_projectile_scene.instance()
	if $Gun/GunPosition != null:
		current_projectile.start($Gun/GunPosition.global_position, rotation, use_spread)
		get_parent().add_child(current_projectile)
		
		if show_bullet_shells:
			var bullet_shells = bullet_shells_scene.instance()
			bullet_shells.global_position = $Arm.global_position
			bullet_shells.global_rotation_degrees = $Arm.global_rotation_degrees
			bullet_shells.get_node("Bullet Shells").emitting = true
			get_parent().add_child(bullet_shells)
		
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
	
	rotate_weapon_wheel()


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
	if not invincible:
		health = health - dmg
		$Camera2D/Interface/TextureRect/AnimationPlayer.play("take_damage")
		Globals.camera.shake(300, 0.5, 300)
		$Camera2D/Interface/VBoxContainer2/ProgressBar.value = health
		if health <= 0 and is_dead == false:
			player_die()
		$InvincibleTimer.start()
		invincible = true


func player_die():
	is_dead = true
	remove_weapon()
	
	if $AnimatedSprite.is_playing():
		$AnimatedSprite.stop()
		
	$AnimatedSprite.play("dead")
	z_index = 0
	get_tree().change_scene("res://UI & Menus/GameOverScreen.tscn")
	print("You have died")


#var weapon_wheel_rotations = 0


func rotate_weapon_wheel():
	var rotate_tween = $Camera2D/Interface/VBoxContainer/Tween
	
	for i in range(visible_wheel_positions.size()):
		visible_wheel_positions[i] = visible_wheel_positions[i] - 1
		if visible_wheel_positions[i] < 0:
			visible_wheel_positions[i] = 5
			
	rotate_tween.interpolate_property(weapon_wheel_sprite, "rotation_degrees", weapon_wheel_sprite.rotation_degrees, weapon_wheel_sprite.rotation_degrees + 60, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	rotate_tween.start()
	
	

func weapon_wheel_follow_pos():
	var current_gun_sprite = get_weapon_sprite(calculate_gun_rotation_index(current_gun_rotation, 0))
	var next_gun_sprite = get_weapon_sprite(calculate_gun_rotation_index(current_gun_rotation, 1))
	var next_gun2_sprite = get_weapon_sprite(calculate_gun_rotation_index(current_gun_rotation, 2))
	var last_gun_sprite = get_weapon_sprite(calculate_gun_rotation_index(current_gun_rotation, -1))
	var last_gun2_sprite = get_weapon_sprite(calculate_gun_rotation_index(current_gun_rotation, -2))

	current_gun_sprite.global_position = weapon_wheel_positions[visible_wheel_positions[2]].global_position
	next_gun_sprite.global_position = weapon_wheel_positions[visible_wheel_positions[1]].global_position
	next_gun2_sprite.global_position = weapon_wheel_positions[visible_wheel_positions[0]].global_position
	last_gun_sprite.global_position = weapon_wheel_positions[visible_wheel_positions[3]].global_position
	last_gun2_sprite.global_position = weapon_wheel_positions[visible_wheel_positions[4]].global_position

	current_gun_sprite.visible = true
	next_gun_sprite.visible = true
	next_gun2_sprite.visible = true


func calculate_gun_rotation_index(index, d):
	var wat_math = index + d 
	if wat_math >= 7:
		wat_math = wat_math - 7
	elif wat_math < 0:
		wat_math = 7 + wat_math
	return wat_math

	
func get_weapon_sprite(gun_rotation_index):
	if gun_rotation[gun_rotation_index] == "assault":
		return assault_sprite
	elif gun_rotation[gun_rotation_index] == "laser":
		return laser_sprite
	elif gun_rotation[gun_rotation_index] == "pistol":
		return pistol_sprite
	elif gun_rotation[gun_rotation_index] == "rocket_launcher":
		return rocket_sprite
	elif gun_rotation[gun_rotation_index] == "shotgun":
		return shotgun_sprite
	elif gun_rotation[gun_rotation_index] == "smg":
		return smg_sprite
	elif gun_rotation[gun_rotation_index] == "sniper":
		return sniper_sprite
	

func combo_heal():
	if Globals.combo_count == 5:
		health = health + 15
		if health >= max_health:
			health = max_health
	if Globals.combo_count == 10:
		health = health + 20
		if health >= max_health:
			health = max_health
	if Globals.combo_count == 15:
		health = health + 30
		if health >= max_health:
			health = max_health
	if Globals.combo_count == 20:
		health = health + 50
		if health >= max_health:
			health = max_health
	if Globals.combo_count == 25:
		health = health + 75
		if health >= max_health:
			health = max_health
	if Globals.combo_count == 30:
		health = health + 100
		if health >= max_health:
			health = max_health
	if Globals.combo_count == 35:
		health = health + 250
		if health >= max_health:
			health = max_health
	if Globals.combo_count == 40:
		health = health + 300
		if health >= max_health:
			health = max_health
	if Globals.combo_count == 45:
		health = health + 400
		if health >= max_health:
			health = max_health
	if Globals.combo_count == 50:
		health = health + 500
		if health >= max_health:
			health = max_health
	if Globals.combo_count == 55:
		health = health + 600
		if health >= max_health:
			health = max_health
	$Camera2D/Interface/VBoxContainer2/ProgressBar.value = health


func _on_InvincibleTimer_timeout():
	invincible = false
