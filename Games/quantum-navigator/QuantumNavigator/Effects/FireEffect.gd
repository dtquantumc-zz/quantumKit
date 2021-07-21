# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends AnimatedSprite

# Script attached to FireEffect objects
# Duplicate files: res://Effects/Effect.gd
#				   res://Effects/FireEffect.gd
#                  res://Effects/PickUpItemEffect.gd

var animationName = "default"

# Called when the node enters the scene tree for the first time.
# Plays the effect's animation, and attaches a listener for animation completion
func _ready():
	# warning-ignore:return_value_discarded
	connect("animation_finished", self, "_on_animation_finished")
	play(animationName)

# Runs on animation completion - deletes the object
func _on_animation_finished():
	queue_free()
