# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node

# Collection of various stats in the game

export var max_health = 1
export var red_bits = 0 setget set_red_bits
export var blue_bits = 0 setget set_blue_bits
export var max_pickles = 2
export var pickles = 0 setget set_pickles
export var isEncoded = false
export var curr_level = 1 setget set_level
export (NodePath)var curr_camera_rmtrans2d = null setget set_curr_camera_rmtrans2d
export (NodePath)var curr_main_player = null setget set_curr_main_player
export var level2_state = [0, 0, 0] setget set_level2_state


export var can_see_encoder = false setget set_can_see_encoder
export var can_see_decoder = false setget set_can_see_decoder
export var can_see_teleporter = false setget set_can_see_teleporter
export var can_see_fire_hazard = false setget set_can_see_fire_hazard
export var can_see_red_bell_pair = false setget set_can_see_red_bell_pair
export var can_see_blue_bell_pair = false setget set_can_see_blue_bell_pair
export var camera_locked = false setget set_camera_locked

onready var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal pickles_changed(value)
signal red_bits_changed(value)
signal blue_bits_changed(value)
signal level_changed(value)
signal camera_locked_changed(value)
signal max_pickles_collected

signal encoder_visible(value)
signal decoder_visible(value)
signal teleporter_visible(value)
signal fire_hazard_visible(value)
signal red_bell_pair_visible(dict)
signal blue_bell_pair_visible(dict)

signal camera_rmtrans2d_changed(nodepath)
signal curr_main_player_changed(nodepath)
signal level2_state_changed(array)


# Setter for the current health, and emits a signal
func set_health(value):
	health = value
	print(health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

# Setter for number of pickles collected, and emits a signal
func set_pickles(value):
	pickles = value
	emit_signal("pickles_changed", pickles)
	if pickles == max_pickles:
		emit_signal("max_pickles_collected")

# Setter for number of red bits collected, and emits a signal
func set_red_bits(value):
	red_bits = value
	emit_signal("red_bits_changed", red_bits)

# Setter for number of blue bits collected, and emits a signal
func set_blue_bits(value):
	blue_bits = value
	emit_signal("blue_bits_changed", blue_bits)

# Sets the current value without emitting a signal
func set_level_no_signal(value):
	curr_level = value

# Setter for the current level (used to update the UI)
# Note: assumes scene had already changed
func set_level(value):
	curr_level = value
	emit_signal("level_changed", curr_level)

# Resets per-level stats, but does not reset to initial level
func reset():
	pickles = 0
	health = max_health
	red_bits = 0
	blue_bits = 0
	set_level2_state([2, 0, 2])
	isEncoded = false

# Setter for can_see_encoder, but emits a signal
func set_can_see_encoder(value):
	can_see_encoder = value
	emit_signal("encoder_visible", can_see_encoder)

# Setter for can_see_decoder, but emits a signal
func set_can_see_decoder(value):
	can_see_decoder = value
	emit_signal("decoder_visible", can_see_decoder)

# Setter for can_see_teleporter, but emits a signal
func set_can_see_teleporter(dict):
	can_see_teleporter = dict.value
	emit_signal("teleporter_visible", dict)

# Setter for can_see_fire_hazard, but emits a signal
func set_can_see_fire_hazard(value):
	can_see_fire_hazard = value
	emit_signal("fire_hazard_visible", can_see_fire_hazard)

# Setter for can_see_red_ball_pair, but emits a signal
func set_can_see_red_bell_pair(dict):
	can_see_red_bell_pair = dict.value
	emit_signal("red_bell_pair_visible", dict)

# Setter for can_see_blue_bell_pair, but emits a signal
# Note: duplicate emit_signal purpose is unknown
func set_can_see_blue_bell_pair(dict):
	can_see_blue_bell_pair = dict.value
	emit_signal("blue_bell_pair_visible", dict)
	emit_signal("blue_bell_pair_visible", dict)
	
func set_camera_locked(value):
	camera_locked = value
	emit_signal("camera_locked_changed", camera_locked)
	
func set_curr_camera_rmtrans2d(nodepath):
	curr_camera_rmtrans2d = nodepath
	emit_signal("camera_rmtrans2d_changed", curr_camera_rmtrans2d)
	
func set_curr_main_player(nodepath):
	curr_main_player = nodepath
	emit_signal("curr_main_player_changed", curr_main_player)

func set_level2_state(array):
	level2_state = array
	print(array)
	emit_signal("level2_state_changed", level2_state)
