# MIT License

# Copyright (c) 2020 Heart GameDev

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

extends Node2D

# Script attached to grass objects

# Preloaded grass effect
const GrassEffect = preload("res://Effects/GrassEffect.tscn")

# Creates a grass effect at this object's current position
func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

# Runs upon an object entering the 'hurtbox'
# Upon object entering the hurtbox, create the grass effect and delete the object
func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
