# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Control

var fire_hazard_visible = {} setget set_fire_hazard_visible

onready var icon = $Icon
onready var label = $Label

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

func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("fire_hazard_visible", self, "set_fire_hazard_visible")