# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Control

# Script that controls background music

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var audioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
# Internally sets the pause mode
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

# Starts playing the background music
func start_music():
	audioStreamPlayer.play()

# Stops playing the background music
func stop_music():
	audioStreamPlayer.stop()

# Determines if the background music is currently playing
func is_playing() -> bool:
	return audioStreamPlayer.is_playing()
