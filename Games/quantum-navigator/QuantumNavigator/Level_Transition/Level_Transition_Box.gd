# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Area2D

export(String) var nextScene = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#

func _on_Area2D_area_entered(area):
	if nextScene != null:
		OtterStats.reset()
		TeleporterState.reset()
		get_tree().change_scene_to(load(nextScene))
	else:
		get_tree().quit()
