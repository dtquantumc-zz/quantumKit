# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends KinematicBody2D

# Script attached to the pickle objects

const PickupItemEffect : PackedScene = preload("res://Effects/PickUpItemEffect.tscn")
const PickleCollectionSound : PackedScene = preload("res://Pickle/PickleCollectionSound.tscn")

# Creates a pickup item effect at the pickle's position
func create_pickupitem_effect():
	var pickupItemEffect = PickupItemEffect.instance()
	get_parent().add_child(pickupItemEffect)
	pickupItemEffect.global_position = global_position

# Upon object entering the hurtbox, increase the number of pickles,
# play the effect, and delete the object
func _on_Hurtbox_area_entered(_area):
	OtterStats.pickles += 1
	create_pickupitem_effect()

	var pickleCollectionSound = PickleCollectionSound.instance()
	get_parent().add_child(pickleCollectionSound)

	queue_free()
