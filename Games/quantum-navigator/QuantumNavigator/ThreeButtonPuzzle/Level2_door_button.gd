extends Node2D

# Script attached to the buttons in Level 2

# export allows the value to be modified in inspector with type specified
export(int,"Button 1", "Button 2", "Button 3") var ButtonID : int = 0;

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var buttonsprite : Sprite = $button_sprite
var up_button : Texture = preload("res://ThreeButtonPuzzle/StaticButton.png")
var pressed_button : Texture = preload("res://ThreeButtonPuzzle/StaticPushedButton.png")

# Called when the node enters the scene tree for the first time.
# Sets the texture of the button to be the unpressed button
func _ready():
	buttonsprite.set_texture(up_button)

# Runs upon an object (presumably an otter) entering this button area
# Changes the state of the level 2 lights according to this button's ID
# and changes the texture
func _on_DoorButton1_area_entered(_area):
	var game_state = OtterStats.level2_state
	match ButtonID:
		0:
			game_state[0] = (game_state[0] + 1) % 3
			game_state[1] = (game_state[1] + 1) % 3
		1:
			game_state[1] = (game_state[1] + 1) % 3
			game_state[2] = (game_state[2] + 1) % 3
		_:
			game_state[2] = (game_state[2] + 1) % 3
			game_state[0] = (game_state[0] + 1) % 3
		
	buttonsprite.set_texture(pressed_button)
	OtterStats.set_level2_state(game_state)

# Runs upon an object (presumably an otter) exiting this button area
# Updates the texture to be the unpressed button
func _on_DoorButton1_area_exited(_area):
	buttonsprite.set_texture(up_button)
