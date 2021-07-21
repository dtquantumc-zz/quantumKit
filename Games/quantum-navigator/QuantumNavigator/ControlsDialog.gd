# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script to display the game controls info box

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var dialogPlayer = $Dialog_Player

# Called upon physics update (_delta = time between physics updates)
# Displays the game controls info box upon 'controls' key pressed
func _physics_process(_delta):
	if Input.is_action_just_pressed("controls") && !InfoDialogOpenState.get_is_info_dialog_open():
		dialogPlayer.play_dialog("GameControlsInfoBox")
