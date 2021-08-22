extends "res://Characters/Enemies/EnemyBaseScript.gd"

var explosion_scene = preload("res://Characters/Enemies/GrenadeExplosion.tscn")

func _ready():
	speed = 170
	health = 1
	attack_damage = 20
	reload_time = 1
	attack_distance = 50
	
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
			speed = 170

func fire_weapon():
	var explosion_object = explosion_scene.instance()
	explosion_object.global_position = position

	get_parent().add_child(explosion_object)
	queue_free()

func take_enemy_damage(dmg):
	health = health - dmg
	if health <= 0 and is_dead == false:
		die()
	else:
		$AnimationPlayer.play("hit_animation")
	play_random_sound()

func play_random_sound():
	randomize()
	var rand = randi()%4+1
	match rand:
		1: $AudioSFX1.play()
		2: $AudioSFX2.play()
		3: $AudioSFX3.play()
		4: $AudioSFX4.play()
	
