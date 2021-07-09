# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Control

var max_bits = 2

var red_bits = 2 setget set_red_bits
var blue_bits = 2 setget set_blue_bits

onready var redBitFull = $RedEntanglementBitFull
onready var redBitEmpty = $RedEntanglementBitEmpty
onready var blueBitFull = $BlueEntanglementBitFull
onready var blueBitEmpty = $BlueEntanglementBitEmpty

func on_level_changed(value):
	print('level changed')
	if value == 1:
		redBitFull.rect_size.x = 0
		redBitEmpty.rect_size.x = 0
	else:
		redBitEmpty.rect_size.x = 28
	
func set_red_bits(value):
	red_bits = clamp(value, 0, max_bits)
	if redBitFull != null:
		redBitFull.rect_size.x = red_bits * 14

func set_blue_bits(value):
	
	blue_bits = clamp(value, 0, max_bits)
	if blueBitFull != null:
		blueBitFull.rect_size.x = blue_bits * 14

func _ready():
	self.red_bits = OtterStats.red_bits
	self.blue_bits = OtterStats.blue_bits
	# warning-ignore:return_value_discarded
	OtterStats.connect("red_bits_changed", self, "set_red_bits")
	# warning-ignore:return_value_discarded
	OtterStats.connect("blue_bits_changed", self, "set_blue_bits")
	OtterStats.connect("level_changed", self, "on_level_changed")
	
	if OtterStats.curr_level == 1:
		redBitFull.rect_size.x = 0
		redBitEmpty.rect_size.x = 0
		
