# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# The RightBoulder explodes on the decoder being called
# The boulder should be deleted on explosion
# See also: res://Boulders/LeftBoulder

# Create an explosion effect instance and add it to the current scene
func create_explosion_effect():
	var ExplosionEffect = load("res://Effects/BoulderExplosionEffect.tscn")
	var explosionEffect = ExplosionEffect.instance()
	var world = get_tree().current_scene
	world.add_child(explosionEffect)
	explosionEffect.global_position = global_position

# Creates an explosion effect and deletes this object at the end of the frame
func on_decoder_used():
	create_explosion_effect()
	queue_free()

# Called when the node enters the scene tree for the first time.
# Adds a listener to CustomSignals to call on_decoder_used when the
# "Decoder Used" signal is fired
# See also: CustomSignals (see res://CustomSignals.gd for info)
func _ready():
	CustomSignals.connect("decoder_used", self, "on_decoder_used")
