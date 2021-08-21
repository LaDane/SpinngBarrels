extends Area2D

var explosion_sfx = preload("res://SFX/SFX_guns/Kenney gun sound export Rocket hit Explosion.wav")
var damage = 20

func _ready():
	$Audio.play(1.0)
	$Explosion.play("explode")
	

func _on_Timer_timeout():
	queue_free()


func _on_RocketExplosion_body_entered(body):
	if body.has_method("take_enemy_damage"):
		pass
	if body.has_method("take_damage"):
		pass
