# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

const ENTANGLEMENT_BIT_SPEED = 200
const UTIL = preload("res://Utility.gd")

var direction = null
var color = UTIL.BLUE

func start(_direction):
	direction = _direction
	adjust_bit_color()

func _process(delta):
	var motion = direction * ENTANGLEMENT_BIT_SPEED
	set_global_position(get_global_position() + motion * delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Hitbox_area_entered(_area):
	queue_free()

func adjust_bit_color():
	if TeleporterState.current_bit_color == UTIL.RED:
		pass # Default color is red
	elif TeleporterState.current_bit_color == UTIL.BLUE:
		set_blue_bit_color()

func set_blue_bit_color():
	var blue_bit = load("res://UI/BlueEntanglementBitFull.png")
	get_node("Sprite").set_texture(blue_bit)