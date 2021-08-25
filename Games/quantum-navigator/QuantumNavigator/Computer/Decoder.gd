# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script to be placed on the decoder
# See also: res://Computer/Computer.gd

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

var decoder_used = false

# Called upon physics update (_delta = time between physics updates)
# Hides/shows the dialogue if the player is within the player detection zone
func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		OtterStats.set_can_see_decoder(true)
		if Input.is_action_just_pressed("info") || !InfoDialogState.get_has_decoder_dialog_been_seen():
			dialogPlayer.play_dialog("DecoderInfoBox")

		if !InfoDialogState.get_has_decoder_dialog_been_seen():
			InfoDialogState.set_has_decoder_dialog_been_seen(true)
	else:
		OtterStats.set_can_see_decoder(false)
		dialogPlayer.stop_dialog()

# Creates the computer effect in scene and gives the effect the otter
# toTeleport = Otter in area
func create_decoder_effect(toTeleport):
	var DecoderEffect = load("res://Effects/DecoderEffect.tscn")
	var decoderEffect = DecoderEffect.instance()
	var world = get_tree().current_scene
	world.add_child(decoderEffect)
	decoderEffect.global_position = global_position
	decoderEffect.connectTeleport( toTeleport )

# Runs upon an object entering the 'hurtbox'
# Note: hurtbox is not to be confused with the player detection zone
# _area = otter/object that enters the hurtbox;
# Creates the computer effect if the conditions are met:
#   -   The decoder has not been used
#   -   The otter has enough followers (i.e. 1)
#   -   The encoder has been used
func _on_Hurtbox_area_entered(_area):
	if (!decoder_used and _area.owner.followers.size() >= 1 and _area.owner.stats.isEncoded):
		create_decoder_effect(_area.owner)
		CustomSignals.emit_signal("decoder_used")
		decoder_used = true
