extends Area2D

# Currently unused script
# Script that appears to control the texture of a door depending on whether
# it is locked/unlocked

onready var light = $"../light"
onready var doorcollision = $"../door_collision"
onready var doorsprite = $"../door_sprite"
var door_locked = preload("res://ThreeButtonPuzzle/StaticLockedDoor.png")
var door_unlocked = preload("res://ThreeButtonPuzzle/StaticUnlockedDoor.png")
var door_open = preload("res://ThreeButtonPuzzle/StaticOpenDoor.png")

func _on_Area2D_area_entered(area):
	if doorcollision.disabled == true:
		doorsprite.set_texture(door_open)

func _on_Area2D_area_exited(area):
	if doorcollision.disabled == true:
		doorsprite.set_texture(door_unlocked)
