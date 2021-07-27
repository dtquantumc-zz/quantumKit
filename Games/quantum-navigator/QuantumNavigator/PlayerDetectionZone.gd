# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Area2D

# Script attached to PlayerDetectionZone objects
# (basically an object that detects player enter/exit)

var player = null
var players = []

# Determines if the player is inside this player detection zone
func can_see_player() -> bool:
	return player != null

# Called upon object entering detection zone
# Save entered body in an array of objects that are currently in the zone
func _on_PlayerDetectionZone_body_entered(body):
	print("entered detected: " + str(body))
	player = body
	players.append(body)

# Called upon object exiting detection zone
# Remove exiting body from the array of objects currently in the zone
func _on_PlayerDetectionZone_body_exited(_body):
	print("exit detected: " + str(_body))
	players.erase(_body)
	if players.size() == 0:
		player = null
	else:
		player = players[0]
