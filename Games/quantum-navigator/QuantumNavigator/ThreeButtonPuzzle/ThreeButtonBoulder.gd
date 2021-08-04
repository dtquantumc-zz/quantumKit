# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# The Boulder explodes upon signal_explode being called (and should be deleted
# after explosion)

const ExplosionEffect = preload("res://Effects/BoulderExplosionEffect.tscn")

# Create an explosion effect instance and add it to the current scene
func create_explosion_effect():
	var explosionEffect = ExplosionEffect.instance()
	var world = get_tree().current_scene
	world.add_child(explosionEffect)
	explosionEffect.global_position = global_position

# Creates an explosion effect and deletes this object at the end of the frame
func signal_explode():
	create_explosion_effect()
	queue_free()
