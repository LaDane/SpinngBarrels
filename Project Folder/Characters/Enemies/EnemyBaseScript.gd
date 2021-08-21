extends KinematicBody2D

onready var Player = get_parent().get_parent().get_node("Player")
var speed = 0
var health = 0
var attack_distance = 200

var is_dead = false
var player_visible = false

var direction = Vector2.ZERO
var motion = Vector2()

var attack_damage = 0
var weapon_ready = true
var reload_time = 0

func _ready():
	$Timer.connect("timeout",self,"_on_Timer_timeout") 
	$Timer.wait_time = rand_range(0.1, 0.2)
	
	$ReloadTime.connect("timeout",self,"_on_ReloadTime_timeout") 


func set_reload_time(reload_time):
	$ReloadTime.wait_time = reload_time


func chase_target():
	var look = $RayCast2D
	look.cast_to = (Player.position - position)
	look.force_raycast_update()

	if look.get_collider().name == "Player":
		player_visible = true
	else:
		player_visible = false

	if !look.is_colliding():
		direction = look.cast_to.normalized()
		$RotationNode.look_at(Player.position)
		
	else:
		for scent in Player.scent_trail:
			look.cast_to = (scent.position - position)
			look.force_raycast_update()

			if !look.is_colliding():
				direction = look.cast_to.normalized()
				$RotationNode.look_at(scent.position)
				break


func _physics_process(delta):
	move()


func move():
	motion = direction * speed
	motion = move_and_slide(motion, Vector2(0,0))


func _on_Timer_timeout():
	chase_target()


func _on_ReloadTime_timeout():
	weapon_ready = true


func take_enemy_damage(dmg):
	health = health - dmg
	if health <= 0 and is_dead == false:
		die()


func die():
	is_dead = true
	queue_free()
