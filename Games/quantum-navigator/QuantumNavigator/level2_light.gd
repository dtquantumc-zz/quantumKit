extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var light = $light
onready var doorcollision = $door_collision
onready var doorsprite = $door_sprite
var red_light = preload("res://LightBulb/StaticRedBulb.png")
var yellow_light = preload("res://LightBulb/StaticYellowBulb.png")
var green_light = preload("res://LightBulb/StaticGreenBulb.png")
var door_locked = preload("res://Assets/StaticLockedDoor.png")
var door_unlocked = preload("res://Assets/StaticUnlockedDoor.png")
var door_open = preload("res://Assets/StaticOpenDoor.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	OtterStats.connect("level2_state_changed", self, "_on_level_state_changed")
	# set current state
	_on_level_state_changed(OtterStats.level2_state)
	
func _on_level_state_changed(state):
	var curr_light_state
	
	if self.name == "door1":
		curr_light_state = state[0]
	if self.name == "door2":
		curr_light_state = state[1]
	if self.name == "door3":
		curr_light_state = state[2]
		
	if curr_light_state == 0:
		self.light.set_texture(red_light)
	if curr_light_state == 1:
		self.light.set_texture(yellow_light)
	if curr_light_state == 2:
		self.light.set_texture(green_light)
		
	if state == [2, 2, 2]:
		doorcollision.set_deferred("disabled", true)
		print(doorcollision.disabled)
		doorsprite.set_texture(door_unlocked)
	else:
		doorcollision.set_deferred("disabled", false)
		doorsprite.set_texture(door_locked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_door1_area_entered(area):
	if doorcollision.disabled == true:
		doorsprite.set_texture(door_open)


func _on_door1_area_exited(area):
	if doorcollision.disabled == true:
		doorsprite.set_texture(door_unlocked)
