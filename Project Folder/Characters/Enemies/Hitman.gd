extends "res://Characters/Enemies/EnemyBaseScript.gd"

var pistol_projectile_scene = preload("res://Characters/Enemies/HitmanProjectile.tscn")
var bullet_shells_scene = preload("res://Particles/Bullet Particles.tscn")

func _ready():
	speed = 100
	health = 100
	attack_damage = 20
	reload_time = 1
	attack_distance = 350
	
	set_reload_time(reload_time)


func _physics_process(delta):
	check_range()


func check_range():
	if player_visible:
		if (global_position.distance_to(Player.global_position)) <= attack_distance:
			speed = 0
			if weapon_ready and !is_dead:
				fire_weapon();
				weapon_ready = false
		else:
			speed = 120


func fire_weapon():
	var projectile_object
	projectile_object = pistol_projectile_scene.instance()
	$AudioWeapon.play(0.95)
	
	projectile_object.set_collision_layer_bit(4, false)
	projectile_object.set_collision_layer_bit(5, true)
	projectile_object.set_collision_mask_bit(2, false)

	projectile_object.start($RotationNode/Position2D.global_position, $RotationNode.rotation, false)

	get_parent().add_child(projectile_object)
	
	var bullet_shells = bullet_shells_scene.instance()
	bullet_shells.global_position = $RotationNode/Position2D.global_position
	bullet_shells.global_rotation_degrees = $RotationNode/Position2D.global_rotation_degrees
	bullet_shells.get_node("Bullet Shells").emitting = true
	get_parent().add_child(bullet_shells)

func take_enemy_damage(dmg):
	health = health - dmg
	if health <= 0 and is_dead == false:
		die()
	else:
		$AnimationPlayer.play("hit_animation")
	play_random_sound()

func play_random_sound():
	randomize()
	var rand = randi()%7+1
	match rand:
		1: $AudioSFX1.play()
		2: $AudioSFX2.play()
		3: $AudioSFX3.play()
		4: $AudioSFX4.play()
		5: $AudioSFX5.play()
		6: $AudioSFX6.play()
		7: $AudioSFX7.play()
