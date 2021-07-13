# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script to be attached to the SpikeTrap object to create the spikes

const SpikeEffectResource = preload("res://Effects/SpikeEffect.tscn")

# Instantiate and create a spike trap
func create_spike_effect():
	var spikeEffect = SpikeEffectResource.instance()
	var world = get_tree().current_scene
	world.add_child(spikeEffect)
	spikeEffect.global_position = global_position
	
# Runs upon an object entering the 'hurtbox'
# Creates a spike effect and deletes this object
func _on_Hurtbox_area_entered(_area):
	create_spike_effect()
	queue_free()

# Runs upon an object exiting the 'hurtbox'
# Creates a spike effect and deletes this object
func _on_Hurtbox_area_exited(area):
	create_spike_effect()
	queue_free()
