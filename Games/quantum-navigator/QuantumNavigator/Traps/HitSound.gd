# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends AudioStreamPlayer

# Script attached to the hit sound object to auto-delete the object upon
# the sound completing

# Called when the node enters the scene tree for the first time.
# Attaches a listener to the sound object to delete this object
func _ready():
	# warning-ignore:return_value_discarded
	connect("finished", self, "queue_free")
