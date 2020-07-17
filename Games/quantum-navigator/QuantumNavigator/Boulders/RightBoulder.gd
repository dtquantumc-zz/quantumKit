extends Node2D

# The RightBoulder explodes on the decoder being called

func create_explosion_effect():
	var ExplosionEffect = load("res://Effects/BoulderExplosionEffect.tscn")
	var explosionEffect = ExplosionEffect.instance()
	var world = get_tree().current_scene
	world.add_child(explosionEffect)
	explosionEffect.global_position = global_position

func on_decoder_used():
	create_explosion_effect()
	queue_free()

func _ready():
	CustomSignals.connect("decoder_used", self, "on_decoder_used")
