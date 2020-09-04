# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends KinematicBody2D

const PickupItemEffect = preload("res://Effects/PickUpItemEffect.tscn")
const PickleCollectionSound = preload("res://Pickle/PickleCollectionSound.tscn")

func create_pickupitem_effect():
	var pickupItemEffect = PickupItemEffect.instance()
	get_parent().add_child(pickupItemEffect)
	pickupItemEffect.global_position = global_position

func _on_Hurtbox_area_entered(_area):
	OtterStats.pickles += 1
	create_pickupitem_effect()

	var pickleCollectionSound = PickleCollectionSound.instance()
	get_parent().add_child(pickleCollectionSound)

	queue_free()
