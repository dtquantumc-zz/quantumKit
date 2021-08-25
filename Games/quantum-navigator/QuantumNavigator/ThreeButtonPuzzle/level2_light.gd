extends Node2D

# Script attached to the doors with lights in Level 2

# export allows the value to be modified in inspector with type specified
export(int,"Door 1","Door 2","Door 3") var DoorID : int = 0
# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var LightObject : Sprite = $light

var red_light : Texture = preload("res://ThreeButtonPuzzle/LightBulb/StaticRedBulb.png")
var yellow_light : Texture = preload("res://ThreeButtonPuzzle/LightBulb/StaticYellowBulb.png")
var green_light : Texture = preload("res://ThreeButtonPuzzle/LightBulb/StaticGreenBulb.png")
var door_locked : Texture = preload("res://ThreeButtonPuzzle/StaticLockedDoor.png")
var door_unlocked : Texture = preload("res://ThreeButtonPuzzle/StaticUnlockedDoor.png")
var door_open : Texture = preload("res://ThreeButtonPuzzle/StaticOpenDoor.png")

signal should_explode()

# Called when the node enters the scene tree for the first time.
# Attaches a listener to level 2 state changing (i.e. a button being pressed)
# and updates textures
func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("level2_state_changed", self, "_on_level_state_changed")
	# set current state
	_on_level_state_changed(OtterStats.level2_state)
	
# Updates the texture of the light object according to the new state
# If state is equal to [2,2,2] (win state), signal that the boulders should explode
func _on_level_state_changed(state):
	match state[DoorID]: # state[DoorId] is the current light state of this door
		0:
			LightObject.set_texture(red_light)
		1:
			LightObject.set_texture(yellow_light)
		2:
			LightObject.set_texture(green_light)
		
	if state == [2, 2, 2]:
		emit_signal("should_explode")
