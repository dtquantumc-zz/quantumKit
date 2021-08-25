# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Area2D

# Script attached to PlayerDetectionZone objects
# (basically an object that detects player enter/exit)

export(bool) var Debug : bool = false

var player = null
var players : Array = []

# Determines if the player is inside this player detection zone
func can_see_player() -> bool:
	return player != null

# Called upon object entering detection zone
# Save entered body in an array of objects that are currently in the zone
func _on_PlayerDetectionZone_body_entered(body):
	if (Debug):
		print("[PlayerDetectionZone _on_PDZ_body_entered]: " + str(body))
	player = body
	players.append(body)

# Called upon object exiting detection zone
# Remove exiting body from the array of objects currently in the zone
func _on_PlayerDetectionZone_body_exited(_body):
	if (Debug):
		print("[PlayerDetectionZone _on_PDZ_body_exited]: " + str(_body))
	players.erase(_body)
	if players.size() == 0:
		player = null
	else:
		player = players[0]
