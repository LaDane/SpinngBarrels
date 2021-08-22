extends "res://Characters/Enemies/EnemyBaseScript.gd"

var pistol_projectile_scene = preload("res://Characters/Enemies/SniperProjectile.tscn")
var bullet_shells_scene = preload("res://Particles/Bullet Particles.tscn")

func _ready():
	speed = 100
	health = 100
	attack_damage = 50
	reload_time = 3
	attack_distance = 750
	
	set_reload_time(reload_time)
	$Line2D.visible = false


func _physics_process(delta):
	$Line2D.global_position = Vector2.ZERO
	check_range()


func check_range():
	if player_visible:
		if (global_position.distance_to(Player.global_position)) <= attack_distance:
			$RotationNode.look_at(Player.position)
			$Line2D.visible = true
			$Line2D.points[0] = $RotationNode/Position2D.global_position
			$Line2D.points[1] = Player.global_position
			speed = 0
			if weapon_ready and !is_dead:
				fire_weapon();
				weapon_ready = false
		else:
			speed = 120
			$Line2D.visible = false	
	else:
		$Line2D.visible = false	


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
