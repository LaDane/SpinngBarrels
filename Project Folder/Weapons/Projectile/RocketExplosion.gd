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
		pass


func _on_CollisionTimer_timeout():
	$CollisionShape2D.disabled = true
