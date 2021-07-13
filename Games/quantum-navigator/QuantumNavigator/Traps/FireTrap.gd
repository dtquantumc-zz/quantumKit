# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script attached to the fire trap
const FireEffectResource = preload("res://Effects/FireEffect.tscn")

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

# Called upon physics update (_delta = time between physics updates)
# Checks if the player can see the fire trap, and shows/hides the info box if so
func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		OtterStats.set_can_see_fire_hazard({"name": get_name(), "value": true})
		if Input.is_action_just_pressed("info") || !InfoDialogState.get_has_fire_trap_dialog_been_seen():
			dialogPlayer.play_dialog("FireHazardInfoBox")

		if !InfoDialogState.get_has_fire_trap_dialog_been_seen():
			InfoDialogState.set_has_fire_trap_dialog_been_seen(true)
	else:
		OtterStats.set_can_see_fire_hazard({"name": get_name(), "value": false})
		dialogPlayer.stop_dialog()

# Creates the fire effect in the scene and sets its position
func create_fire_effect():
	var fireEffect = FireEffectResource.instance()
	var world = get_tree().current_scene
	world.add_child(fireEffect)
	fireEffect.global_position = global_position

# Runs upon an object entering the 'hitbox'
# Note: hurtbox is not to be confused with the player detection zone
# Creates the fire effect upon object entering the hitbox
func _on_Hitbox_area_entered(_area):
	create_fire_effect()
