extends Node2D

const UTIL = preload("res://Utility.gd")

func on_teleporters_are_connected(texture):
	get_node("Sprite").set_texture(texture)

func _ready():
	TeleporterState.connect("teleporters_are_connected", self, "on_teleporters_are_connected")

func _on_Hurtbox_area_entered(area):
	if TeleporterState.are_all_teleporters_connected():
		return

	update_teleporter_state()

	if all_red_teleporters_are_same_color():
		TeleporterState.are_red_teleporters_connected = true
	elif all_blue_teleporters_are_same_color():
		TeleporterState.are_blue_teleporters_connected = true
	else:
		update_teleporter_color()

func update_teleporter_state():
	if TeleporterState.current_bit_color == UTIL.RED:
		handle_red_bit_fired()
	else:
		handle_blue_bit_fired()

func all_red_teleporters_are_same_color():
	return TeleporterState.num_red_teleporters == TeleporterState.num_teleporters

func all_blue_teleporters_are_same_color():
	return TeleporterState.num_blue_teleporters == TeleporterState.num_teleporters

func update_teleporter_color():
	if TeleporterState.current_bit_color == UTIL.RED:
		set_red_teleporter_color()
	else:
		set_blue_teleporter_color()

func set_red_teleporter_color():
	var red_teleporter = load("res://Teleporter/RedPhoneBooth/PhoneBoothClosed.png")
	get_node("Sprite").set_texture(red_teleporter)

func set_blue_teleporter_color():
	var blue_teleporter = load("res://Teleporter/BluePhoneBooth/PhoneBoothClosed.png")
	get_node("Sprite").set_texture(blue_teleporter)

func handle_red_bit_fired():
	OtterStats.red_bits -= 1
	TeleporterState.current_bit_color = UTIL.RED
	TeleporterState.num_red_teleporters += 1

func handle_blue_bit_fired():
	OtterStats.blue_bits -= 1
	TeleporterState.current_bit_color = UTIL.BLUE
	TeleporterState.num_blue_teleporters += 1

func _on_InteractableHurtbox_area_entered(area):
	if !TeleporterState.are_all_teleporters_connected():
		return

	if TeleporterState.are_red_teleporters_connected:
		var openedRedTeleporter = load("res://Teleporter/RedPhoneBooth/PhoneBoothOpenConnected.png")
		get_node("Sprite").set_texture(openedRedTeleporter)
	else:
		var openedBlueTeleporter = load("res://Teleporter/BluePhoneBooth/PhoneBoothOpenConnected.png")
		get_node("Sprite").set_texture(openedBlueTeleporter)
