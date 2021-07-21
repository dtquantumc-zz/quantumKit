# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script to be placed on the encoder
# See also: res://Computer/Decoder.gd

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

var encoder_used = false

# Called upon physics update (_delta = time between physics updates)
# Hides/shows the dialogue if the player is within the player detection zone
func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		OtterStats.set_can_see_encoder(true)
		if Input.is_action_just_pressed("info") || !InfoDialogState.get_has_encoder_dialog_been_seen():
			dialogPlayer.play_dialog("EncoderInfoBox")

		if !InfoDialogState.get_has_encoder_dialog_been_seen():
			InfoDialogState.set_has_encoder_dialog_been_seen(true)
	else:
		OtterStats.set_can_see_encoder(false)
		dialogPlayer.stop_dialog()

# Creates the computer effect in scene and gives the effect the otter
# toTeleport = Otter in area
func create_computer_effect(toTeleport):
	var ComputerEffect = load("res://Effects/ComputerEffect.tscn")
	var computerEffect = ComputerEffect.instance()
	var world = get_tree().current_scene
	world.add_child(computerEffect)
	computerEffect.global_position = global_position
	computerEffect.connectTeleport( toTeleport )

# Runs upon an object entering the 'hurtbox'
# Note: hurtbox is not to be confused with the player detection zone
# _area = otter/object that enters the hurtbox;
# Creates the computer effect if otter has enough pickles and encoder has
# not already been used
func _on_Hurtbox_area_entered(_area):
#	print(_area.owner.stats.pickles)
	if (!encoder_used and _area.owner.stats.pickles >= 2):
		_area.owner.stats.pickles -= 2
		create_computer_effect(_area.owner)
		encoder_used = true
