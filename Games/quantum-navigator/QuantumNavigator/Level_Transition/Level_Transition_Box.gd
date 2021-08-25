# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Area2D

# Script attached to the Level_Transition_Box
# Note: use LevelCompleteMessage instead for the "Level Complete!" transition
# See also: res://Level_Transition/LevelCompleteMessage/LevelCompleteMessage.gd

# export allows the value to be modified in inspector with type specified
export(String) var nextScene = null

# Method runs upon another object entering this Area2D object
# On entering this Area2D object, go to the next scene
func _on_Area2D_area_entered(_area):
	if nextScene != null:
		SaveManager.save_progress(nextScene)
		OtterStats.reset()
		OtterStats.set_level(OtterStats.curr_level + 1)
		TeleporterState.reset()
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(load(nextScene))
	else:
		get_tree().quit()
