# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script attached to GameIntro object

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

# Called upon physics update (_delta = time between physics updates)
# Hides/shows the game intro dialog if player is within the player detection zone
func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		if !InfoDialogState.get_has_game_intro_dialog_been_seen():
			dialogPlayer.play_dialog("GameIntroInfoBox")

		if !InfoDialogState.get_has_game_intro_dialog_been_seen():
			InfoDialogState.set_has_game_intro_dialog_been_seen(true)
	else:
		dialogPlayer.stop_dialog()
