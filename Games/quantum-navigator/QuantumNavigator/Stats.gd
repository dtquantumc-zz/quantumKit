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
export var curr_level = 1 setget set_level
export (NodePath)var curr_camera_rmtrans2d = null setget set_curr_camera_rmtrans2d
export (NodePath)var curr_main_player = null setget set_curr_main_player
export var level2_state = [false, false, false] setget set_level2_state


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
	
func set_level(value):
	# used to update the UI, assume scene already changed
	curr_level = value
	emit_signal("level_changed", curr_level)

func reset():
	# reset per level only, does not reset level
	pickles = 0
	health = max_health
	red_bits = 0
	blue_bits = 0
	level2_state = [false, false, false]
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
