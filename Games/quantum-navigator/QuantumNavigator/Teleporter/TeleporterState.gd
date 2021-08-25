# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node

# Script attached to the global teleporter state object

const UTIL = preload("res://Utility.gd")

var num_teleporters : int = 2 setget set_num_teleporters
var num_red_teleporters : int = 0 setget set_num_red_teleporters
var num_blue_teleporters : int = 0 setget set_num_blue_teleporters
var current_bit_color = UTIL.RED setget set_current_bit_color
var are_red_teleporters_connected : bool = false setget set_are_red_teleporters_connected
var are_blue_teleporters_connected : bool = false setget set_are_blue_teleporters_connected

var activeTeleporters : Array = []

# Defined signal upon teleporter connection
signal teleporters_are_connected(value)

# Setter for the number of teleporters, but clamps it to a non-negative value
func set_num_teleporters(value : int):
	num_teleporters = int(max(value, 0))
	
# Setter for the number of red teleporters, but clamps it to a non-negative valuev
func set_num_red_teleporters(value : int):
	num_red_teleporters = int(max(value, 0))

# Setter for the number of blue teleporters, but clamps it to a non-negative value
func set_num_blue_teleporters(value : int):
	num_blue_teleporters = int(max(value, 0))

# Setter for the current color of bits
func set_current_bit_color(value):
	current_bit_color = value

# Setter for whether red teleporters are connected, and if so, emits a signal
func set_are_red_teleporters_connected(value: bool):
	are_red_teleporters_connected = value
	if (are_red_teleporters_connected):
		emit_red_teleporters_are_connected_signal()

# Setter for whether blue teleporters are connected, and if so, emits a signal
func set_are_blue_teleporters_connected(value: bool):
	are_blue_teleporters_connected = value
	if (are_blue_teleporters_connected):
		emit_blue_teleporters_are_connected_signal()

# Setter for whether one pair of teleporters are connected
func are_all_teleporters_connected() -> bool:
	return are_red_teleporters_connected || are_blue_teleporters_connected

# Emits the teleporters_are_connected signal, and attaches an image of which
# teleporter was connected (i.e. a red one)
func emit_red_teleporters_are_connected_signal():
	var connected_red_teleporter : Texture = load("res://Teleporter/RedPhoneBooth/PhoneBoothClosedGlowing.png")
	emit_signal("teleporters_are_connected", connected_red_teleporter)

# Emits the teleporters_are_connected signal, and attaches an image of which
# teleporter was connected (i.e. a blue one)
func emit_blue_teleporters_are_connected_signal():
	var connected_blue_teleporter : Texture = load("res://Teleporter/BluePhoneBooth/PhoneBoothClosedGlowing.png")
	emit_signal("teleporters_are_connected", connected_blue_teleporter)

# Resets all variables/counts of teleporters and states
func reset():
	num_teleporters = 2
	num_red_teleporters = 0
	num_blue_teleporters = 0
	current_bit_color = UTIL.RED
	are_red_teleporters_connected = false
	are_blue_teleporters_connected = false

	activeTeleporters = []
