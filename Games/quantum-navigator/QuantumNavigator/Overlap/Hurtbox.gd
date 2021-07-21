# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Area2D

# Script attached to an object that can be invincible for a set duration

var invincible = false setget set_invincible

onready var timer = timer

# Define signals upon invincibility start/finish
signal invincibility_started
signal invincibility_ended

# Setter for invincible value that emits signals
func set_invincible(value: bool):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

# Begins the invincibility for a specified duration
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

# On timer end, turn off invincibility
func _on_Timer_timeout():
	self.invincible = false

# On hurtbox invincibility beginning, set monitorable to false
func _on_Hurtbox_invincibility_started():
	set_deferred("monitorable", false)

# On hurtbox invincibility ending, set monitorable to true
func _on_Hurtbox_invincibility_ended():
	monitorable = true
