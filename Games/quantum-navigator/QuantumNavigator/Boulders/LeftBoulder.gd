# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# The LeftBoulder explodes on max pickles being collected
# The LeftBoulder should be deleted upon explosion
# See also: res://Boulders/RightBoulder

# Create an explosion effect instance and add it to the current scene
func create_explosion_effect():
	var ExplosionEffect = load("res://Effects/BoulderExplosionEffect.tscn")
	var explosionEffect = ExplosionEffect.instance()
	var world = get_tree().current_scene
	world.add_child(explosionEffect)
	explosionEffect.global_position = global_position

# Creates an explosion effect and deletes this object at the end of the frame
func on_max_pickles_collected():
	create_explosion_effect()
	queue_free()


# Called when the node enters the scene tree for the first time.
# Set the method on_max_pickles_collected to listen to signals from
# OtterStats (see res://Stats.gd for info)
func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("max_pickles_collected", self, "on_max_pickles_collected")
