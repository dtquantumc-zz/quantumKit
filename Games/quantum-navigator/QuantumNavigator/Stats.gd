# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node

export var max_health = 1
export var red_bits = 0 setget set_red_bits
export var blue_bits = 0 setget set_blue_bits
export var max_pickles = 2
export var pickles = 0 setget set_pickles
export var isEncoded = false

export var can_see_encoder = false setget set_can_see_encoder
export var can_see_decoder = false setget set_can_see_decoder
export var can_see_teleporter = false setget set_can_see_teleporter
export var can_see_fire_hazard = false setget set_can_see_fire_hazard
export var can_see_red_bell_pair = false setget set_can_see_red_bell_pair
export var can_see_blue_bell_pair = false setget set_can_see_blue_bell_pair

onready var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal pickles_changed(value)
signal red_bits_changed(value)
signal blue_bits_changed(value)
signal max_pickles_collected

signal encoder_visible(value)
signal decoder_visible(value)
signal teleporter_visible(value)
signal fire_hazard_visible(value)
signal red_bell_pair_visible(dict)
signal blue_bell_pair_visible(dict)

func set_health(value):
	health = value
	print(health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_pickles(value):
	pickles = value
	emit_signal("pickles_changed", pickles)
	if pickles == max_pickles:
		emit_signal("max_pickles_collected")

func set_red_bits(value):
	red_bits = value
	emit_signal("red_bits_changed", red_bits)

func set_blue_bits(value):
	blue_bits = value
	emit_signal("blue_bits_changed", blue_bits)

func reset():
	pickles = 0
	health = max_health
	red_bits = 0
	blue_bits = 0
	isEncoded = false

func set_can_see_encoder(value):
	can_see_encoder = value
	emit_signal("encoder_visible", can_see_encoder)

func set_can_see_decoder(value):
	can_see_decoder = value
	emit_signal("decoder_visible", can_see_decoder)

func set_can_see_teleporter(dict):
	can_see_teleporter = dict.value
	emit_signal("teleporter_visible", dict)

func set_can_see_fire_hazard(value):
	can_see_fire_hazard = value
	emit_signal("fire_hazard_visible", can_see_fire_hazard)

func set_can_see_red_bell_pair(dict):
	can_see_red_bell_pair = dict.value
	emit_signal("red_bell_pair_visible", dict)

func set_can_see_blue_bell_pair(dict):
	can_see_blue_bell_pair = dict.value
	emit_signal("blue_bell_pair_visible", dict)
	emit_signal("blue_bell_pair_visible", dict)
