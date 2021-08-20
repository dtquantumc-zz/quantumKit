extends Node2D

enum DoorState {
	LOCKED, UNLOCKED, OPEN	
}

onready var SpriteObject = $Sprite
onready var CollisionObject = $StaticBody2D

export(String) var LockedSpritePath = "res://Door/StaticClosedDoorSide.png";
export(String) var UnlockedSpritePath = "res://Door/StaticClosedDoorSide.png";
export(String) var OpenSpritePath = "res://Door/StaticOpenDoorSide.png";
export(String) var DoorFramePath = "res://Door/DoorFrame.tscn"
export(String) var DoorFrameTexturePath = "res://Door/StaticClosedDoorSide.png"
export(DoorState) var InitialDoorState = DoorState.UNLOCKED;

var DoorFrame = load(DoorFramePath)
var DoorFrameTexture = load(DoorFrameTexturePath)
var LockedSprite = load(LockedSpritePath)
var UnlockedSprite = load(UnlockedSpritePath)
var OpenSprite = load(OpenSpritePath)
var CurrentDoorState = InitialDoorState

var _created_door_frame = null

func update_collision():
	CollisionObject.get_node("CollisionShape2D").disabled = CurrentDoorState != DoorState.LOCKED

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
func _ready():
	CurrentDoorState = DoorState.LOCKED
	switch_to_correct_texture()
	#update_collision()

func unlock_door():
	if (CurrentDoorState == DoorState.LOCKED):
		CurrentDoorState = DoorState.UNLOCKED
		switch_to_correct_texture()
		#update_collision()
		
func lock_door():
	CurrentDoorState = DoorState.LOCKED
	switch_to_correct_texture()
	#update_collision()

func _on_Area2D_body_entered(body):
	if (CurrentDoorState == DoorState.UNLOCKED):
		CurrentDoorState = DoorState.OPEN
		switch_to_correct_texture()
#		_created_door_frame = DoorFrame.instance()
#		_created_door_frame.transform = transform
#		_created_door_frame.set_sprite(DoorFrameTexture)
#		get_tree().current_scene.add_child(_created_door_frame)


func _on_Area2D_body_exited(body):
	if (CurrentDoorState == DoorState.OPEN):
		CurrentDoorState = DoorState.UNLOCKED
#		_created_door_frame.queue_free()
		switch_to_correct_texture()
