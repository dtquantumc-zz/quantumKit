# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends KinematicBody2D

# Script attached to the RedEntanglementBitCollectable object
# (red floaty orbs)
# See also: res://EntanglementBit/BlueEntanglementBitCollectable.gd

# Preload various scenes/prefabs to be created later
const PickupItemEffect : PackedScene = preload("res://Effects/PickUpItemEffect.tscn")
const BitCollectionSound : PackedScene = preload("res://EntanglementBit/BitCollectionSound.tscn")

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

var bit_collected : bool = false

# Called upon physics update (_delta = time between physics updates)
# Hide/show help info box upon near entanglement bit
func _physics_process(_delta):
	if !bit_collected and playerDetectionZone.can_see_player():
		OtterStats.set_can_see_red_bell_pair({"name": get_name(), "value": true})
		if Input.is_action_just_pressed("info")|| !InfoDialogState.get_has_bell_pair_dialog_been_seen():
			dialogPlayer.play_dialog("BellPairsInfoBox")

		if !InfoDialogState.get_has_bell_pair_dialog_been_seen():
			InfoDialogState.set_has_bell_pair_dialog_been_seen(true)
	else:
		OtterStats.set_can_see_red_bell_pair({"name": get_name(), "value": false})
		dialogPlayer.stop_dialog()

# Instantiates the PickupItemEffect object and moves it to its current position
func create_pickupitem_effect():
	var pickupItemEffect = PickupItemEffect.instance()
	get_parent().add_child(pickupItemEffect)
	pickupItemEffect.global_position = global_position

# Runs upon an object entering the 'hurtbox'
# Note: hurtbox is not to be confused with the player detection zone
# Increases the number of red bits of the otter, hides the info box if open,
# plays the correct sound, and deletes the object.
func _on_Hurtbox_area_entered(_area):
	# increase number of red bits
	OtterStats.red_bits += 1
	
	# Create pickup item effect
	create_pickupitem_effect()

	# Hide info box
	OtterStats.set_can_see_red_bell_pair({"name": get_name(), "value": false})
	dialogPlayer.stop_dialog()
	bit_collected = true

	# Generate sound
	var bitCollectionSound = BitCollectionSound.instance()
	get_parent().add_child(bitCollectionSound)

	# Delete object
	queue_free()
