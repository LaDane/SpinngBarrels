extends "res://Characters/Enemies/EnemyBaseScript.gd"

var pistol_projectile_scene = preload("res://Weapons/Projectile/PistolProjetile.tscn")

func _ready():
	speed = 100
	health = 100
	attack_damage = 20
	reload_time = 2
	attack_distance = 200
	
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
			speed = 120


func fire_weapon():
	var projectile_object
	projectile_object = pistol_projectile_scene.instance()
	$AudioWeapon.play(0.95)
	
	projectile_object.set_collision_layer_bit(4, false)
	projectile_object.set_collision_layer_bit(5, true)
	projectile_object.set_collision_mask_bit(2, false)

	projectile_object.start($RotationNode/Position2D.global_position, $RotationNode.rotation)

	get_parent().add_child(projectile_object)
