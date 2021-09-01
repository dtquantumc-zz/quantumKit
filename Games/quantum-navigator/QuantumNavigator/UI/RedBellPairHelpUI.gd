# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Control

# Script attached to the help UI item for red bell pairs

var red_bell_pair_visible = {} setget set_red_bell_pair_visible

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var icon = $Icon
onready var label = $Label

# Set position/visibility of the bell pair
func set_red_bell_pair_visible(dict):
	red_bell_pair_visible[dict.name] = dict.value
	if red_bell_pair_visible.values().has(true):
		icon.rect_size.x = 28
		icon.rect_size.y = 14
		label.set_percent_visible(1)
	else:
		icon.rect_size.x = 0
		icon.rect_size.y = 0
		label.set_percent_visible(0)

# Called when the node enters the scene tree for the first time.
# Add a listener for red_bell_pair_visible upon entering the scene
# See Also: res://Stats.gd
func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("red_bell_pair_visible", self, "set_red_bell_pair_visible")
	icon.rect_size.x = 0
	icon.rect_size.y = 0
	label.set_percent_visible(0)
