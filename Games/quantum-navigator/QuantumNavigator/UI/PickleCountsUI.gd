# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Control

# Script attached to the help UI item for pickles

var pickles = 0 setget set_pickles

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var label = $Label

# Sets the internal value of pickles and changes the displayed text
func set_pickles(value):
	pickles = max(value, 0)
	if label != null:
		label.text = str(pickles)

# Called when the node enters the scene tree for the first time.
# Add a listener for pickles_changed upon entering the scene
# See Also: res://Stats.gd
func _ready():
	self.pickles = OtterStats.pickles
	# warning-ignore:return_value_discarded
	OtterStats.connect("pickles_changed", self, "set_pickles")
