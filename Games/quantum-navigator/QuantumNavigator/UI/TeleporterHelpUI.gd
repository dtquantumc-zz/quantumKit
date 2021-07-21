# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Control

# Script attached to the small teleporter help icon in the UI

var teleporter_visible = {} setget set_teleporter_visible

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var icon = $Icon
onready var label = $Label

# Sets location/visibility of the teleporter given an input dictionary
func set_teleporter_visible(dict):
	teleporter_visible[dict.name] = dict.value

	if teleporter_visible.values().has(true):
		icon.rect_size.x = 25
		icon.rect_size.y = 52
		label.set_percent_visible(1)
	else:
		icon.rect_size.x = 0
		icon.rect_size.y = 0
		label.set_percent_visible(0)
		
# Called when the node enters the scene tree for the first time.
# Add a listener to teleporter_visible to call set_teleporter_visible
func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("teleporter_visible", self, "set_teleporter_visible")
