extends Node2D

func create_fire_effect():
	var FireEffect = load("res://Effects/FireEffect.tscn")
	var fireEffect = FireEffect.instance()
	var world = get_tree().current_scene
	world.add_child(fireEffect)
	fireEffect.global_position = global_position

func _on_Hitbox_area_entered(_area):
	create_fire_effect()
