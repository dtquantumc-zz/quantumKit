# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node

const UTIL = preload("res://Utility.gd")

var num_teleporters = 2 setget set_num_teleporters
var num_red_teleporters = 0 setget set_num_red_teleporters
var num_blue_teleporters = 0 setget set_num_blue_teleporters
var current_bit_color = UTIL.RED setget set_current_bit_color
var are_red_teleporters_connected = false setget set_are_red_teleporters_connected
var are_blue_teleporters_connected = false setget set_are_blue_teleporters_connected

var activeTeleporters = []

signal teleporters_are_connected(value)

func set_num_teleporters(value):
	num_teleporters = max(value, 0)

func set_num_red_teleporters(value):
	num_red_teleporters = max(value, 0)

func set_num_blue_teleporters(value):
	num_blue_teleporters = max(value, 0)

func set_current_bit_color(value):
	current_bit_color = value

func set_are_red_teleporters_connected(value):
	are_red_teleporters_connected = value
	if (are_red_teleporters_connected):
		emit_red_teleporters_are_connected_signal()

func set_are_blue_teleporters_connected(value):
	are_blue_teleporters_connected = value
	if (are_blue_teleporters_connected):
		emit_blue_teleporters_are_connected_signal()

func are_all_teleporters_connected():
	return are_red_teleporters_connected || are_blue_teleporters_connected

func emit_red_teleporters_are_connected_signal():
	var connected_red_teleporter = load("res://Teleporter/RedPhoneBooth/PhoneBoothClosedGlowing.png")
	emit_signal("teleporters_are_connected", connected_red_teleporter)

func emit_blue_teleporters_are_connected_signal():
	var connected_blue_teleporter = load("res://Teleporter/BluePhoneBooth/PhoneBoothClosedGlowing.png")
	emit_signal("teleporters_are_connected", connected_blue_teleporter)

func reset():
	num_teleporters = 2
	num_red_teleporters = 0
	num_blue_teleporters = 0
	current_bit_color = UTIL.RED
	are_red_teleporters_connected = false
	are_blue_teleporters_connected = false

	activeTeleporters = []
