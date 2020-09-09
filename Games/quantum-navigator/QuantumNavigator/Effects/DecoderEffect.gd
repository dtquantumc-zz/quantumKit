# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends AnimatedSprite

var toTeleport = null

signal decoder_effect_done(position)
signal decoder_effect_start

func _ready():
	frame = 0
	play("Animate")

func connectTeleport(toTeleport):
	self.connect("decoder_effect_done",
		toTeleport,
		"_on_Decoder_effect_process_done")
	toTeleport.call("_on_Decoder_effect_process_start")

func _on_DecoderEffect_animation_finished():
	emit_signal("decoder_effect_done", position)
