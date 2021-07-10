# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends AudioStreamPlayer

func _ready():
	connect("finished", self, "queue_free")
