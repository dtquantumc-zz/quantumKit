# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends AudioStreamPlayer

func _ready():
	# warning-ignore:return_value_discarded
	connect("finished", self, "queue_free")