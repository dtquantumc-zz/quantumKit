extends Node2D

onready var doorcollision = $door_collision
onready var doorsprite = $door_sprite
var door_locked = preload("res://ThreeButtonPuzzle/StaticLockedDoor.png")
var door_unlocked = preload("res://ThreeButtonPuzzle/StaticUnlockedDoor.png")
var door_open = preload("res://ThreeButtonPuzzle/StaticOpenDoor.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	doorcollision.set_deferred("disabled", false) # should this be true???
	doorsprite.set_texture(door_unlocked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	OtterStats.curr_main_player.followers.size()
	
func make_closed():
	doorcollision.set_deferred("disabled", false)
	doorsprite.set_texture(door_locked)
