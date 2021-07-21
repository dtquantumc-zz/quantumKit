# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Control

# Script attached to the help UI item for fire hazards

var fire_hazard_visible = {} setget set_fire_hazard_visible

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var icon = $Icon
onready var label = $Label

# Set position/visibility of the help icon
func set_fire_hazard_visible(dict):
	fire_hazard_visible[dict.name] = dict.value

	if fire_hazard_visible.values().has(true):
		icon.rect_size.x = 26
		icon.rect_size.y = 32
		label.set_percent_visible(1)
	else:
		icon.rect_size.x = 0
		icon.rect_size.y = 0
		label.set_percent_visible(0)
		
# Called when the node enters the scene tree for the first time.
# Add a listener for fire_hazard_visible upon entering the scene
# See Also: res://Stats.gd
func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("fire_hazard_visible", self, "set_fire_hazard_visible")
