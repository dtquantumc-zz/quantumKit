# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script attached to global level control

# Restarts the level with a given time delay
func restart(time=0):
	if time > 0:
		yield(get_tree().create_timer(time), "timeout")
	OtterStats.reset()
	TeleporterState.reset()
	get_tree().reload_current_scene()

# Adds a restart call to a queue of actions with a time delay of 1 second
func queue_restart():
	self.call_deferred("restart", 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Determines if restart button is pressed, and if so, restart immediately
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		restart()

