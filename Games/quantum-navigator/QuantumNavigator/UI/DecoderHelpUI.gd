# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Control

# Script attached to the Decoder Help UI icon

var decoder_visible = false setget set_decoder_visible

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var icon = $Icon
onready var label = $Label

# Setter for decoder_visible that adjusts the label and icon visibility
func set_decoder_visible(value):
	decoder_visible = value

	if decoder_visible:
		icon.rect_size.x = 64
		icon.rect_size.y = 64
		label.set_percent_visible(1)
	else:
		icon.rect_size.x = 0
		icon.rect_size.y = 0
		label.set_percent_visible(0)

# Called when the node enters the scene tree for the first time.
# Attach a listener to decoder_visible
# See also: res://Stats.gd
func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("decoder_visible", self, "set_decoder_visible")


