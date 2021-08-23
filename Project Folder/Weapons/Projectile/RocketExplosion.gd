extends Area2D

var explosion_sfx = preload("res://SFX/SFX_guns/Kenney gun sound export Rocket hit Explosion.wav")
var damage = 100

func _ready():
	$Audio.play(1.0)
	$Explosion.play("explode")
	

func _on_Timer_timeout():
	queue_free()


func _on_RocketExplosion_body_entered(body):
	if body.has_method("take_enemy_damage"):
		body.take_enemy_damage(damage)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	print(get_collision_layer())
	print(get_collision_mask())


func _on_CollisionTimer_timeout():
	$CollisionShape2D.disabled = true
