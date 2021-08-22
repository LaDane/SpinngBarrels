extends "res://Characters/Enemies/EnemyBaseScript.gd"

var pistol_projectile_scene = preload("res://Characters/Enemies/HitmanProjectile.tscn")
var bullet_shells_scene = preload("res://Particles/Bullet Particles.tscn")
var fired_shots = 0
var allowed_fired_shots = 2
var timer_running = false

func _ready():
	speed = 0
	health = 700
	attack_damage = 15
	reload_time = 2
	attack_distance = 400
	
	set_reload_time(reload_time)


func _physics_process(delta):
	check_range()


func check_range():
	if player_visible:
		$RotationNode.look_at(Player.position)
		if (global_position.distance_to(Player.global_position)) <= attack_distance:
			speed = 0
			if weapon_ready and !timer_running:
				timer_running = true
				$GunTimer.start()
				$AudioWeapon.play(1.0)
#		else:
#			speed = 120


func fire_weapon():
	var projectile_object = pistol_projectile_scene.instance()
	
	projectile_object.set_collision_layer_bit(4, false)
	projectile_object.set_collision_layer_bit(5, true)
	projectile_object.set_collision_mask_bit(2, false)

	projectile_object.start($RotationNode/Position2D.global_position, $RotationNode.rotation, true)

	get_parent().add_child(projectile_object)
	
	var bullet_shells = bullet_shells_scene.instance()
	bullet_shells.global_position = $RotationNode/Position2D.global_position
	bullet_shells.global_rotation_degrees = $RotationNode/Position2D.global_rotation_degrees
	bullet_shells.get_node("Bullet Shells").emitting = true
	get_parent().add_child(bullet_shells)


func _on_GunTimer_timeout():
	fire_weapon();
	fired_shots = fired_shots + 1
	if fired_shots > allowed_fired_shots:
		timer_running = false
		weapon_ready = false
		fired_shots = 0
	else:
		$GunTimer.start()
	
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
