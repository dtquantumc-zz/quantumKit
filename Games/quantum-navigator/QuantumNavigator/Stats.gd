# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node

# Collection of various stats in the game

export(int) var max_health : int = 1
export(int) var red_bits : int = 0 setget set_red_bits
export(int) var blue_bits : int = 0 setget set_blue_bits
export(int) var max_pickles : int = 2
export(int) var pickles : int = 0 setget set_pickles
export(bool) var isEncoded : bool = false
export(int) var curr_level : int = 1 setget set_level
export(NodePath) var curr_camera_rmtrans2d = null setget set_curr_camera_rmtrans2d
export(NodePath) var curr_main_player = null setget set_curr_main_player
export(Array, int) var level2_state : Array = [0, 0, 0] setget set_level2_state


export(bool) var can_see_encoder : bool = false setget set_can_see_encoder
export(bool) var can_see_decoder : bool = false setget set_can_see_decoder
export(bool) var can_see_teleporter : bool = false setget set_can_see_teleporter
export var can_see_fire_hazard = false setget set_can_see_fire_hazard
export(bool) var can_see_red_bell_pair : bool = false setget set_can_see_red_bell_pair
export(bool) var can_see_blue_bell_pair : bool = false setget set_can_see_blue_bell_pair
export(bool) var camera_locked : bool = false setget set_camera_locked
export(bool) var measurement_area : bool = false setget set_measurement_area
export(int) var keys : int= 0 setget set_keys
export(int) var level3_progress: int=0 setget set_level3_progress

onready var health : int = max_health setget set_health

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

signal measurement_area_changed(value)
signal keys_changed(value)


# Setter for the current health, and emits a signal
func set_health(value : int):
	health = value
	print(health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

# Setter for number of pickles collected, and emits a signal
func set_pickles(value : int):
	pickles = value
	emit_signal("pickles_changed", pickles)
	if pickles == max_pickles:
		emit_signal("max_pickles_collected")

# Setter for number of red bits collected, and emits a signal
func set_red_bits(value : int):
	red_bits = value
	emit_signal("red_bits_changed", red_bits)

# Setter for number of blue bits collected, and emits a signal
func set_blue_bits(value : int):
	blue_bits = value
	emit_signal("blue_bits_changed", blue_bits)

# Sets the current value without emitting a signal
func set_level_no_signal(value : int):
	curr_level = value

# Setter for the current level (used to update the UI)
# Note: assumes scene had already changed
func set_level(value : int):
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
	set_measurement_area(false)
	keys = 0

# Setter for can_see_encoder, but emits a signal
func set_can_see_encoder(value : bool):
	can_see_encoder = value
	emit_signal("encoder_visible", can_see_encoder)

# Setter for can_see_decoder, but emits a signal
func set_can_see_decoder(value : bool):
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

# Setter for whether the camera is locked
func set_camera_locked(value : bool):
	camera_locked = value
	emit_signal("camera_locked_changed", camera_locked)

# Setter for the 2D transform object the current camera has
func set_curr_camera_rmtrans2d(nodepath):
	curr_camera_rmtrans2d = nodepath
	emit_signal("camera_rmtrans2d_changed", curr_camera_rmtrans2d)

# Setter for the current main player
func set_curr_main_player(nodepath):
	curr_main_player = nodepath
	emit_signal("curr_main_player_changed", curr_main_player)

# Setter for the level 2 state
func set_level2_state(array : Array):
	level2_state = array
	print("[Stats.gd set_level2_state]: " + str(array))
	emit_signal("level2_state_changed", level2_state)

# Setter for the current measurement area
func set_measurement_area(value):
	print("[Stats.gd set_measurement_area]: " + str(value))
	measurement_area = value
	emit_signal("measurement_area_changed", measurement_area)

# Setter for the number of keys
func set_keys(value : int):
	keys = value
	emit_signal('keys_changed', value)
	
func set_level3_progress(value: int):
	level3_progress = value

# Increments keys by one
func inc_keys():
	set_keys(keys + 1)
