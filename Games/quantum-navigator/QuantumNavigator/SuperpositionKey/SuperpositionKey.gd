extends Node2D

# Script attached to the key with spatial superposition in level 4

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var KeySprite = $Sprite
onready var Hitbox = $Hitbox

onready var dialogPlayer = $Dialog_Player
onready var playerDetectionZone = $PlayerDetectionZone
# export allows the value to be modified in inspector with type specified
export(bool) var in_key_area : bool = false
export(float) var MinRenderOpacity : float = 0.1

var probability : float = 0 setget set_probability
var is_solid : bool = false
var has_measured : bool = false
var objects_in_hitbox : Array = []

# Sets the probability (with range [0,1], clamps it otherwise), and adjusts
# the opacity of the sprite (with minimum MinRenderOpacity)
func set_probability(value: float) -> void:
	value = clamp(value,0,1)
	probability=value
	KeySprite.modulate.a = max(MinRenderOpacity,probability)

# Make the sprite disappear (assumes that measurement has occured)
func make_gone() -> void:
	has_measured = true
	KeySprite.modulate.a = 0

# Make the sprite be permanently solid (assumes that measurement has occured)
func make_solid() -> void:
	has_measured = true
	is_solid = true
	KeySprite.modulate.a = 1
	var otter = get_otter()
	if (otter != null):
		make_otter_pickup_key(otter)
	elif (objects_in_hitbox.size() > 0):
		make_enemy_pickup_key(objects_in_hitbox[0])

# Code that would run on enemy picking up this key
# TODO implementation (if needed)
func make_enemy_pickup_key(enemy):
	printerr("----Enemy pickup/inventory code not implemented: Make enemy pick up key----")
	queue_free()

# Code that would run on player picking up this key
# Increments the amount of keys picked up and deletes this object
func make_otter_pickup_key(_otter):
	OtterStats.inc_keys()
	queue_free()

# Returns the otter inside this key hitbux if one exists, null otherwise
func get_otter() -> Node:
	for obj in objects_in_hitbox:
		if (is_object_otter(obj)):
			return obj
	return null

# Determines if given object is an otter
func is_object_otter(obj : Node) -> bool:
	return "Otter" in obj.get_parent().get_name()

# Runs upon an object entering the hitbox
# Internally sets an additional object in the hitbox
# If measured, makes the object pickup the key
func _on_Hitbox_area_entered(area):
	objects_in_hitbox.append(area)
	if (is_solid):
		if (is_object_otter(area)):
			make_otter_pickup_key(area)
		else :
			make_enemy_pickup_key(area)

# Runs upon an object exiting the hitbox
# Internally removes the object from the list of objects in the hitbox
func _on_Hitbox_area_exited(area):
	objects_in_hitbox.erase(area)

# Runs upon an object entering the 'hurtbox'
# Note: not to be confused with hitbox
# Signals internally that the otter is in the 'measurement area'
func _on_Hurtbox2_area_entered(_area):
	self.get_parent().in_measurement_area = true
	in_key_area = true
	OtterStats.set_measurement_area(true)

# Runs upon an object exiting the 'hurtbox'
# Note: not to be confused with hitbox
# Signals internally that the otter is no longer in the 'measurement area'
func _on_Hurtbox2_area_exited(_area):
	self.get_parent().in_measurement_area = false
	in_key_area = false
	OtterStats.set_measurement_area(false)

func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		if Input.is_action_just_pressed("info") || !InfoDialogState.get_has_key_dialog_been_seen():
			dialogPlayer.play_dialog("KeyInfoBox")

		if !InfoDialogState.get_has_key_dialog_been_seen():
			InfoDialogState.set_has_key_dialog_been_seen(true)
	else:
		dialogPlayer.stop_dialog()
