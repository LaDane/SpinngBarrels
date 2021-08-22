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
			if weapon_ready:
				fire_weapon();
				weapon_ready = false
		else:
			speed = 170


func fire_weapon():
	var explosion_object = explosion_scene.instance()

#	projectile_object.set_collision_layer_bit(4, false)
#	projectile_object.set_collision_layer_bit(5, true)
#	projectile_object.set_collision_mask_bit(2, false)
	explosion_object.global_position = position

	get_parent().add_child(explosion_object)
	queue_free()
