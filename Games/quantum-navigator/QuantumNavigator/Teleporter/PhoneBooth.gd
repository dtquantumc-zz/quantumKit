# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

const UTIL = preload("res://Utility.gd")
const grayClosed = preload("res://Teleporter/GrayPhoneBooth/PhoneBoothGray.png")
const redClosed = preload("res://Teleporter/RedPhoneBooth/PhoneBoothClosed.png")
const redClosedGlow = preload("res://Teleporter/RedPhoneBooth/PhoneBoothClosedGlowing.png")
const redOpen = preload("res://Teleporter/RedPhoneBooth/PhoneBoothOpenConnected.png")
const blueClosed = preload("res://Teleporter/BluePhoneBooth/PhoneBoothClosed.png")
const blueClosedGlow = preload("res://Teleporter/BluePhoneBooth/PhoneBoothClosedGlowing.png")
const blueOpen = preload("res://Teleporter/BluePhoneBooth/PhoneBoothOpenConnected.png")

var color = "gray"
var ErrorSound = preload("res://Teleporter/ErrorSound.tscn")

func _ready():
	# warning-ignore:return_value_discarded
	TeleporterState.connect("teleporters_are_connected", self, "on_teleporters_are_connected")

func on_teleporters_are_connected(texture):
	var connected_red_teleporter = load("res://Teleporter/RedPhoneBooth/PhoneBoothClosedGlowing.png")
	var connected_blue_teleporter = load("res://Teleporter/BluePhoneBooth/PhoneBoothClosedGlowing.png")

	var is_red_teleporter_connected = texture == connected_red_teleporter
	var is_blue_teleporter_connected = texture == connected_blue_teleporter

	for pair in TeleporterState.activeTeleporters:
		if pair[0] == self:
			if pair[1] == 'red' && is_red_teleporter_connected:
				get_node("Sprite").set_texture(texture)
			elif pair[1] == 'blue'&& is_blue_teleporter_connected:
				get_node("Sprite").set_texture(connected_blue_teleporter)
			break

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

func _on_Hurtbox_area_entered(_area):
	if !is_gray_phone_booth():
		return

	update_teleporter_state()

	if two_red_teleporters_are_same_color():
		TeleporterState.are_red_teleporters_connected = true
	elif two_blue_teleporters_are_same_color():
		TeleporterState.are_blue_teleporters_connected = true

	update_teleporter_color()

func is_gray_phone_booth():
	return (get_node("Sprite").get_texture().get_path() ==
	"res://Teleporter/GrayPhoneBooth/PhoneBoothGray.png")

func update_teleporter_state():
	if TeleporterState.current_bit_color == UTIL.RED:
		handle_red_bit_fired()
	else:
		handle_blue_bit_fired()

func two_red_teleporters_are_same_color():
	return TeleporterState.num_red_teleporters == 2

func two_blue_teleporters_are_same_color():
	return TeleporterState.num_blue_teleporters == 2

func all_red_teleporters_are_same_color():
	return TeleporterState.num_red_teleporters == TeleporterState.num_teleporters

func all_blue_teleporters_are_same_color():
	return TeleporterState.num_blue_teleporters == TeleporterState.num_teleporters

func update_teleporter_color():
	if color == 'red' && !two_red_teleporters_are_same_color():
		color = "red"
		set_red_teleporter_color()
	elif color == 'blue' && !two_blue_teleporters_are_same_color():
		color = "blue"
		set_blue_teleporter_color()

func set_red_teleporter_color():
	get_node("Sprite").set_texture(redClosed)

func set_blue_teleporter_color():
	get_node("Sprite").set_texture(blueClosed)

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

func handle_blue_bit_fired():
	OtterStats.blue_bits -= 1

	if OtterStats.blue_bits <= 0:
			TeleporterState.current_bit_color = null

	TeleporterState.num_blue_teleporters += 1
	TeleporterState.activeTeleporters.append([self, 'blue'])
	color = 'blue'

func open_booth():
	if color == "red":
		$Sprite.set_texture(redOpen)
	else:
		$Sprite.set_texture(blueOpen)

func close_booth():
	if color == "red":
		$Sprite.set_texture(redClosedGlow)
	else:
		$Sprite.set_texture(blueClosedGlow)

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

func _on_InteractableHurtbox_area_entered(area):
	if !TeleporterState.are_all_teleporters_connected() or area.owner.stats.isEncoded == true:
		var errorSound = ErrorSound.instance()
		get_parent().add_child(errorSound)

		return

	var is_a_red_connected_teleporter = $Sprite.texture == redClosedGlow
	var is_a_blue_connected_teleporter = $Sprite.texture == blueClosedGlow

	var is_a_connected_teleporter = is_a_red_connected_teleporter or is_a_blue_connected_teleporter

	if !([self, color] in TeleporterState.activeTeleporters) or !is_a_connected_teleporter:
		var errorSound = ErrorSound.instance()
		get_parent().add_child(errorSound)

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

	$Teleport_Timer.connect(
		"timeout",
		self,
		"make_Teleport",
		[toTeleport, otherBooth],
		CONNECT_ONESHOT
	)
	$Teleport_Timer.start(0.7)

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
	complete_Teleport(null)

func complete_Teleport(toTeleport):
	if (toTeleport != null):
		toTeleport.visible = true
		toTeleport.isTeleporting = false

#	close_booth()
	set_gray()


