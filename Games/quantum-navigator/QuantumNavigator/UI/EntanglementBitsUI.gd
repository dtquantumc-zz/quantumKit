# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Control

# Script attached to the EntanglementBitsUI object that displays red and blue
# bit counts

var max_bits : int = 2

var red_bits : int = 2 setget set_red_bits
var blue_bits : int = 2 setget set_blue_bits

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var redBitFull = $RedEntanglementBitFull
onready var redBitEmpty = $RedEntanglementBitEmpty
onready var blueBitFull = $BlueEntanglementBitFull
onready var blueBitEmpty = $BlueEntanglementBitEmpty

# Code that runs on a level change to adjust positions of entanglement bits
func on_level_changed(value: int):
	print("[EntanglementBitsUI on_level_changed]: " + str(value))
	match value:
		1:
			redBitFull.rect_size.x = 0
			redBitEmpty.rect_size.x = 0
		2:
			redBitFull.rect_size.x = 0
			redBitEmpty.rect_size.x = 0
		_:
			redBitEmpty.rect_size.x = 28

# Setter for red_bits, after clamping it to a range of [0, max_bits]
func set_red_bits(value : int):
	red_bits = int(clamp(value, 0, max_bits))
	if redBitFull != null:
		redBitFull.rect_size.x = red_bits * 14

# Setter for blue_bits, after clamping it to a range of [0, max_bits]
func set_blue_bits(value : int):
	blue_bits = int(clamp(value, 0, max_bits))
	if blueBitFull != null:
		blueBitFull.rect_size.x = blue_bits * 14

# Called when the node enters the scene tree for the first time.
# Attaches various listeners to OtterStats and initializes internal variables
# to initial starting values
# See Also: res://Stats.gd
func _ready():
	self.red_bits = OtterStats.red_bits
	self.blue_bits = OtterStats.blue_bits
	# warning-ignore:return_value_discarded
	OtterStats.connect("red_bits_changed", self, "set_red_bits")
	# warning-ignore:return_value_discarded
	OtterStats.connect("blue_bits_changed", self, "set_blue_bits")
	# warning-ignore:return_value_discarded
	OtterStats.connect("level_changed", self, "on_level_changed")
	
	if OtterStats.curr_level == 1 or OtterStats.curr_level == 2:
		redBitFull.rect_size.x = 0
		redBitEmpty.rect_size.x = 0
		
