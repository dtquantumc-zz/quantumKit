extends Node2D

# Script attached to "Door" scenes (res://Door/Door.tscn)

# Enumeration defining the state of the door
enum DoorState {
	LOCKED, UNLOCKED, OPEN	
}

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var SpriteObject = $Sprite
onready var CollisionObject = $StaticBody2D

# export allows the value to be modified in inspector with type specified
export(Texture) var LockedSprite = preload("res://Door/StaticClosedDoorSide.png")
export(Texture) var UnlockedSprite =  preload("res://Door/StaticClosedDoorSide.png")
export(Texture) var OpenSprite = preload("res://Door/StaticOpenDoorSide.png")
export(PackedScene) var DoorFrame : PackedScene = preload("res://Door/DoorFrame.tscn")
export(Texture) var DoorFrameTexture : Texture = preload("res://Door/StaticClosedDoorSide.png")
export(DoorState) var InitialDoorState = DoorState.UNLOCKED;

var CurrentDoorState = InitialDoorState

var _created_door_frame = null

# Disables/Enables the collision detection on the collision object according
# to the current door state
func update_collision():
	CollisionObject.get_node("CollisionShape2D").disabled = CurrentDoorState != DoorState.LOCKED

# Loads the correct texture on the sprite object according to current door state
func switch_to_correct_texture():
	match (CurrentDoorState):
		DoorState.UNLOCKED:
			SpriteObject.texture = UnlockedSprite
		DoorState.LOCKED:
			SpriteObject.texture = LockedSprite
		DoorState.OPEN:
			SpriteObject.texture = OpenSprite
		_:
			SpriteObject.texture = UnlockedSprite

# Called when the node enters the scene tree for the first time.
# Switches to correct texture upon load.
func _ready():
	CurrentDoorState = InitialDoorState
	switch_to_correct_texture()
	#update_collision()

# Unlocks the door if the door was locked, and if so, updates the texture
func unlock_door():
	if (CurrentDoorState == DoorState.LOCKED):
		CurrentDoorState = DoorState.UNLOCKED
		switch_to_correct_texture()
		#update_collision()

# Locks the door and updates the texture
func lock_door():
	CurrentDoorState = DoorState.LOCKED
	switch_to_correct_texture()
	#update_collision()

# Runs upon an object entering the door's Area2D
# On object enter and state is unlocked, open the door and switch to correct
# texture.
func _on_Area2D_body_entered(_body):
	print(CurrentDoorState)
	if (CurrentDoorState == DoorState.UNLOCKED):
		print("hi")
		CurrentDoorState = DoorState.OPEN
		switch_to_correct_texture()
#		_created_door_frame = DoorFrame.instance()
#		_created_door_frame.transform = transform
#		_created_door_frame.get_node("Sprite").texture = DoorFrameTexture
#		get_tree().current_scene.add_child(_created_door_frame)

# Runs upon an object exiting the door's Area2D
# On object leave, close the door and update the texture
func _on_Area2D_body_exited(_body):
	if (CurrentDoorState == DoorState.OPEN):
		CurrentDoorState = DoorState.UNLOCKED
#		_created_door_frame.queue_free()
		switch_to_correct_texture()
