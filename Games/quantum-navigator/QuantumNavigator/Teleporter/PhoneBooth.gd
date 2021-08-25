# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script attached to a phone booth object

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

const UTIL = preload("res://Utility.gd")
const grayClosed : Texture = preload("res://Teleporter/GrayPhoneBooth/PhoneBoothGray.png")
const redClosed : Texture = preload("res://Teleporter/RedPhoneBooth/PhoneBoothClosed.png")
const redClosedGlow : Texture = preload("res://Teleporter/RedPhoneBooth/PhoneBoothClosedGlowing.png")
const redOpen : Texture = preload("res://Teleporter/RedPhoneBooth/PhoneBoothOpenConnected.png")
const blueClosed : Texture = preload("res://Teleporter/BluePhoneBooth/PhoneBoothClosed.png")
const blueClosedGlow : Texture = preload("res://Teleporter/BluePhoneBooth/PhoneBoothClosedGlowing.png")
const blueOpen : Texture = preload("res://Teleporter/BluePhoneBooth/PhoneBoothOpenConnected.png")

var color : String = "gray"
var ErrorSound : PackedScene = preload("res://Teleporter/ErrorSound.tscn")

# Called when the node enters the scene tree for the first time.
# Attach a listener upon teleporters being connected
# See Also: res://Teleporter/TeleporterState.gd
func _ready():
	# warning-ignore:return_value_discarded
	TeleporterState.connect("teleporters_are_connected", self, "on_teleporters_are_connected")

# Changes the current texture of the sprite given the texture to load
# and the state of connected/active teleporters
func on_teleporters_are_connected(texture):
	var connected_red_teleporter : Texture = load("res://Teleporter/RedPhoneBooth/PhoneBoothClosedGlowing.png")
	var connected_blue_teleporter : Texture = load("res://Teleporter/BluePhoneBooth/PhoneBoothClosedGlowing.png")

	var is_red_teleporter_connected : bool = texture == connected_red_teleporter
	var is_blue_teleporter_connected : bool = texture == connected_blue_teleporter

	for pair in TeleporterState.activeTeleporters:
		if pair[0] == self:
			if pair[1] == 'red' && is_red_teleporter_connected:
				get_node("Sprite").set_texture(texture)
			elif pair[1] == 'blue' && is_blue_teleporter_connected:
				get_node("Sprite").set_texture(connected_blue_teleporter)
			break

# Called upon physics update (_delta = time between physics updates)
# If a player can be seen, display info boxes if needed
func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		OtterStats.set_can_see_teleporter({"name": get_name(), "value": true})
		if Input.is_action_just_pressed("info") || !InfoDialogState.get_has_teleporter_dialog_been_seen():
			dialogPlayer.play_dialog("TeleporterInfoBox")

		if !InfoDialogState.get_has_teleporter_dialog_been_seen():
			InfoDialogState.set_has_teleporter_dialog_been_seen(true)
	else:
		OtterStats.set_can_see_teleporter({"name": get_name(), "value": false})
		dialogPlayer.stop_dialog()

# Runs upon an object entering the hurtbox
# Updates teleporter state and color if this teleporter is not active
func _on_Hurtbox_area_entered(_area):
	if !is_gray_phone_booth():
		return

	update_teleporter_state()

	if two_red_teleporters_are_same_color():
		TeleporterState.are_red_teleporters_connected = true
	elif two_blue_teleporters_are_same_color():
		TeleporterState.are_blue_teleporters_connected = true

	update_teleporter_color()

# Determines if this phone box is currently a gray phone booth
func is_gray_phone_booth() -> bool:
	return (get_node("Sprite").get_texture().get_path() ==
	"res://Teleporter/GrayPhoneBooth/PhoneBoothGray.png")

# Update the current state of the teleporter according to the current bit color
func update_teleporter_state():
	if TeleporterState.current_bit_color == UTIL.RED:
		handle_red_bit_fired()
	else:
		handle_blue_bit_fired()

# Determines if there are two red teleporters
func two_red_teleporters_are_same_color() -> bool:
	return TeleporterState.num_red_teleporters == 2

# Determines if there are two blue teleporters
func two_blue_teleporters_are_same_color() -> bool:
	return TeleporterState.num_blue_teleporters == 2

# Determines if all teleporters are red
func all_red_teleporters_are_same_color() -> bool:
	return TeleporterState.num_red_teleporters == TeleporterState.num_teleporters

# Determines if all teleporters are blue
func all_blue_teleporters_are_same_color() -> bool:
	return TeleporterState.num_blue_teleporters == TeleporterState.num_teleporters

# Updates the internal teleporter color and changes the sprite
func update_teleporter_color():
	if color == 'red' && !two_red_teleporters_are_same_color():
		color = "red"
		set_red_teleporter_color()
	elif color == 'blue' && !two_blue_teleporters_are_same_color():
		color = "blue"
		set_blue_teleporter_color()

# Changes the sprite to be a red teleporter
func set_red_teleporter_color():
	get_node("Sprite").set_texture(redClosed)

# Changes the sprite to be a blue teleporter
func set_blue_teleporter_color():
	get_node("Sprite").set_texture(blueClosed)

# Change the current color of the teleporter upon a red bit being fired/contact
# and adjust global TeleporterState
func handle_red_bit_fired():
	OtterStats.red_bits -= 1

	if OtterStats.red_bits <= 0:
		if OtterStats.blue_bits > 0:
			TeleporterState.current_bit_color = UTIL.BLUE
		else:
			TeleporterState.current_bit_color = null

	TeleporterState.num_red_teleporters += 1
	TeleporterState.activeTeleporters.append([self, 'red'])
	color = 'red'

# Change the current color of the teleporter upon a blue bit being fired/contact
# and adjust global TeleporterState
func handle_blue_bit_fired():
	OtterStats.blue_bits -= 1

	if OtterStats.blue_bits <= 0:
			TeleporterState.current_bit_color = null

	TeleporterState.num_blue_teleporters += 1
	TeleporterState.activeTeleporters.append([self, 'blue'])
	color = 'blue'

# Set the texture to be an 'open' booth image
func open_booth():
	if color == "red":
		$Sprite.set_texture(redOpen)
	else:
		$Sprite.set_texture(blueOpen)

# Set the texture to be an 'closed' booth image but glowing
func close_booth():
	if color == "red":
		$Sprite.set_texture(redClosedGlow)
	else:
		$Sprite.set_texture(blueClosedGlow)

# Set the texture to be a gray phone booth, and adjust TeleporterState if
# previously not gray
func set_gray():
	$Sprite.set_texture(grayClosed)
	TeleporterState.activeTeleporters.erase([self, color])

	if color == 'red':
		TeleporterState.are_red_teleporters_connected = false
		TeleporterState.num_red_teleporters -= 2
	elif color == 'blue':
		TeleporterState.are_blue_teleporters_connected = false
		TeleporterState.num_blue_teleporters -= 2

	color = 'gray'

# Creates an error sound
func create_error_sound():
	var errorSound = ErrorSound.instance()
	get_parent().add_child(errorSound)

# On interaction, either play an error sound and return, or commence teleportation
# to another phone booth
# Error sound will be played if:
#   -  A pair of teleporters are not connected
#   -  The otter is encoded
#   -  This teleporter is not connected to another teleporter
func _on_InteractableHurtbox_area_entered(area):
	# Prevent teleportation if no pair exists or otter is encoded
	if !TeleporterState.are_all_teleporters_connected() or area.owner.stats.isEncoded == true:
		create_error_sound()
		return

	var is_a_red_connected_teleporter : bool = $Sprite.texture == redClosedGlow
	var is_a_blue_connected_teleporter : bool = $Sprite.texture == blueClosedGlow

	var is_a_connected_teleporter : bool = is_a_red_connected_teleporter or is_a_blue_connected_teleporter
	
	# Prevent teleportation if teleporter is not connected to another teleporter
	if !([self, color] in TeleporterState.activeTeleporters) or !is_a_connected_teleporter:
		create_error_sound()
		return

	var toTeleport = area.owner
	toTeleport.visible = false
	toTeleport.isTeleporting = true

	open_booth()

	var otherBooth = null
	for booth in TeleporterState.activeTeleporters:
		if booth[0] != self and booth[1] == color:
			otherBooth = booth[0]
	if otherBooth == null:
		print("Couldn't find second teleporter!")
		return
	
	# warning-ignore:return_value_discarded
	$Teleport_Timer.connect(
		"timeout",
		self,
		"make_Teleport",
		[toTeleport, otherBooth],
		CONNECT_ONESHOT
	)
	$Teleport_Timer.start(0.7)

# Add a listener to the teleport timer to make the object visible,
# but change its position
func make_Teleport(toTeleport, teleportTo):
	toTeleport.position = teleportTo.position + Vector2(-8, 16)
	teleportTo.get_node("Teleport_Timer").connect(
		"timeout",
		teleportTo,
		"complete_Teleport",
		[toTeleport],
		CONNECT_ONESHOT
	)
	teleportTo.get_node("Teleport_Timer").start(0.3)
	teleportTo.open_booth()
	complete_Teleport(null) # can we replace this with set_gray() ???

# Makes the object visible and non-teleporting upon teleport completion
# If toTeleport is null, this function is equivalent to set_gray
func complete_Teleport(toTeleport):
	if (toTeleport != null):
		toTeleport.visible = true
		toTeleport.isTeleporting = false

#	close_booth()
	set_gray()


