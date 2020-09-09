# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Control

var pickles = 0 setget set_pickles

onready var label = $Label

func set_pickles(value):
	pickles = max(value, 0)
	if label != null:
		label.text = str(pickles)

func _ready():
	self.pickles = OtterStats.pickles
	# warning-ignore:return_value_discarded
	OtterStats.connect("pickles_changed", self, "set_pickles")
