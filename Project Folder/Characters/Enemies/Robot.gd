extends "res://Characters/Enemies/EnemyBaseScript.gd"

var projectile_scene = preload("res://Weapons/Projectile/LaserProjectile.tscn")

func _ready():
	speed = 80
	health = 50
	attack_damage = 20
	reload_time = 3
	attack_distance = 450
	
	set_reload_time(reload_time)


func _physics_process(delta):
	check_range()


func check_range():
	if player_visible:
		if (global_position.distance_to(Player.global_position)) <= attack_distance:
			$RotationNode.look_at(Player.position)
			speed = 0
			if weapon_ready:
				fire_weapon();
				weapon_ready = false
		else:
			speed = 80


func fire_weapon():
	var projectile_object
	projectile_object = projectile_scene.instance()
	$AudioWeapon.play(2.79)
	
	projectile_object.set_collision_layer_bit(4, false)
	projectile_object.set_collision_layer_bit(5, true)
	projectile_object.set_collision_mask_bit(2, false)

	projectile_object.start($RotationNode/Position2D.global_position, $RotationNode.rotation, false)

	get_parent().add_child(projectile_object)
