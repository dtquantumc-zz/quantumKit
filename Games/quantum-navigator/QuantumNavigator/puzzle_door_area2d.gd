extends Area2D

onready var light = $"../light"
onready var doorcollision = $"../door_collision"
onready var doorsprite = $"../door_sprite"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var door_locked = preload("res://Assets/StaticLockedDoor.png")
var door_unlocked = preload("res://Assets/StaticUnlockedDoor.png")
var door_open = preload("res://Assets/StaticOpenDoor.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if doorcollision.disabled == true:
		doorsprite.set_texture(door_open)


func _on_Area2D_area_exited(area):
	if doorcollision.disabled == true:
		doorsprite.set_texture(door_unlocked)
