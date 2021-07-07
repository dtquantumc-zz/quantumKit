extends Node

# What scene we're supposed to move to
export(String) var nextScene = null

# Play animation upon ready
func _ready():
	get_node("DisplayedContent/AnimationPlayer").play("LevelCompleteAnimation")

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
		get_tree().change_scene_to(load(nextScene))
	else:
		get_tree().quit()
