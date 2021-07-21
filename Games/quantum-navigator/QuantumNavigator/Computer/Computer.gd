# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

var encoder_used = false

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

func create_computer_effect(toTeleport):
	var ComputerEffect = load("res://Effects/ComputerEffect.tscn")
	var computerEffect = ComputerEffect.instance()
	var world = get_tree().current_scene
	world.add_child(computerEffect)
	computerEffect.global_position = global_position
	computerEffect.connectTeleport( toTeleport )

func _on_Hurtbox_area_entered(_area):
#	print(_area.owner.stats.pickles)
#	if (!encoder_used and _area.owner.stats.pickles >= 2):
#		_area.owner.stats.pickles -= 2
	if (!encoder_used):
		create_computer_effect(_area.owner)
		encoder_used = true
