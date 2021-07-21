# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends AudioStreamPlayer

# Script attached to the otter hurt sound object

# Called when the node enters the scene tree for the first time.
# Deletes this object when sound is finished
func _ready():
	# warning-ignore:return_value_discarded
	connect("finished", self, "queue_free")
