extends Node

# Script attached to the Level Complete Window
# See also: res://Level_Transition/Level_Transition_Box.gd

# export allows the value to be modified in inspector with type specified
# What scene we're supposed to move to
export(PackedScene) var nextScene : PackedScene = null

# Called when the node enters the scene tree for the first time.
# Play animation upon ready
func _ready():
	get_node("DisplayedContent/AnimationPlayer").play("LevelCompleteAnimation")

# Method runs upon an input event
# On input, check if it's a spacebar press input, and goto next scene
func _input(event):
	if event is InputEventKey:
		if event.pressed == true and (event.scancode == KEY_SPACE):
			goto_next_scene()

# Moves to next scene
func goto_next_scene():
	if nextScene != null:
		OtterStats.reset()
		TeleporterState.reset()
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(nextScene)
	else:
		get_tree().quit()
