# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends AnimatedSprite

# Script to be attached to the decoder effect
# See also: res://Effects/ComputerEffect.gd
#           res://Computer/Decoder.gd

var toTeleport = null
var animationName = "default"

signal decoder_effect_done(position)
signal decoder_effect_start

# Called when the node enters the scene tree for the first time.
# Plays the effect's animation
func _ready():
	frame = 0
	play(animationName)

# Adds a listener to decoder_effect_done that is signaled upon animation finish
# And signals to the toTeleport object that the decoder effect is starting
func connectTeleport(toTeleport):
	self.connect("decoder_effect_done",
		toTeleport,
		"_on_Decoder_effect_process_done")
	toTeleport.call("_on_Decoder_effect_process_start")

# Function called on animation finished - emits a signal when the decoder
# effect is complete
func _on_DecoderEffect_animation_finished():
	emit_signal("decoder_effect_done", position)
