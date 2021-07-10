# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends AnimatedSprite

# Script attached to the SpikeEffect object

var animationName = "default"

# Plays the animation (no listener upon animation completion)
func _ready():
	frame = 0
	play(animationName)
