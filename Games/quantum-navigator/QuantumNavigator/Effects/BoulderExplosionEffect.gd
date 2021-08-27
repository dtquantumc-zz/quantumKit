# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends AnimatedSprite

# Script added to the boulder explosion effect object

var animationName : String = "default"

# Called when the node enters the scene tree for the first time.
# Adds a listener to the animation_finished signal and plays the animation
func _ready():
	# warning-ignore:return_value_discarded
	connect("animation_finished", self, "_on_animation_finished")
	play(animationName)

# Runs on the animation being finished
# Sets the object to be deleted at the end of the frame
func _on_animation_finished():
	queue_free()
