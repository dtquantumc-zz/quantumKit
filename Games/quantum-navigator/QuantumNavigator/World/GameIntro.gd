# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		if !InfoDialogState.get_has_game_intro_dialog_been_seen():
			dialogPlayer.play_dialog("GameIntroInfoBox")

		if !InfoDialogState.get_has_game_intro_dialog_been_seen():
			InfoDialogState.set_has_game_intro_dialog_been_seen(true)
	else:
		dialogPlayer.stop_dialog()
