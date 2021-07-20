# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script to be attached to the computer/encoder effect
# See also: res://Effects/DecoderEffect.gd
#           res://Computer/Computer.gd

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var animatedSprite = $AnimatedSprite

var toTeleport = null
var animationName = "default"

signal computer_effect_done(position)
signal computer_effect_start

# Called when the node enters the scene tree for the first time.
# Plays the effect's animation
func _ready():
	animatedSprite.frame = 0
	animatedSprite.play(animationName)

# Adds a listener to computer_effect_done that is signaled upon animation finish
# And signals to the objectToTeleport that the computer effect is starting
func connectTeleport(objectToTeleport):
	# warning-ignore:return_value_discarded
	self.connect("computer_effect_done",
		objectToTeleport,
		"_on_Computer_effect_process_done")
	objectToTeleport.call("_on_Computer_effect_process_start")

# Function called on animation finished - emits a signal when the computer
# effect is complete
func _on_AnimatedSprite_animation_finished():
	emit_signal("computer_effect_done", position)
