# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

onready var animatedSprite = $AnimatedSprite

var toTeleport = null

signal computer_effect_done(position)
signal computer_effect_start

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Animate")

func connectTeleport(toTeleport):
	self.connect("computer_effect_done",
		toTeleport,
		"_on_Computer_effect_process_done")
	toTeleport.call("_on_Computer_effect_process_start")

func _on_AnimatedSprite_animation_finished():
	emit_signal("computer_effect_done", position)
