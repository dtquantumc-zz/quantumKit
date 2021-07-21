# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script attached to the entanglement bit projectile

const ENTANGLEMENT_BIT_SPEED = 200
const UTIL = preload("res://Utility.gd")

var direction = null
var color = UTIL.BLUE

# Sets the direction and bit color
func start(_direction):
	direction = _direction
	adjust_bit_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Adjusts the position of the projectile every frame
func _process(delta):
	var motion = direction * ENTANGLEMENT_BIT_SPEED
	set_global_position(get_global_position() + motion * delta)

# Deletes this object upon screen exit
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Deletes this object upon an object entering the hitbox
func _on_Hitbox_area_entered(_area):
	queue_free()

# Changes the bit color to the correct bit color
# Note: default color is red
func adjust_bit_color():
	if TeleporterState.current_bit_color == UTIL.RED:
		pass # Default color is red
	elif TeleporterState.current_bit_color == UTIL.BLUE:
		set_blue_bit_color()

# Changes the texture to that of a blue bit
func set_blue_bit_color():
	var blue_bit = load("res://UI/BlueEntanglementBitFull.png")
	get_node("Sprite").set_texture(blue_bit)
