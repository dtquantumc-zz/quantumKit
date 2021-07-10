# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends AudioStreamPlayer

# Script attached to the BitCollectionSound object

# Called when the node enters the scene tree for the first time.
# Add a listener upon audio effect finish to delete the object after it plays
func _ready():
	# warning-ignore:return_value_discarded
	connect("finished", self, "queue_free")
