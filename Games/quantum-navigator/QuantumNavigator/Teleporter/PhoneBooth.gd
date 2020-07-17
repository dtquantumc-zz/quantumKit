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

func _ready():
	TeleporterState.connect("teleporters_are_connected", self, "on_teleporters_are_connected")

func on_teleporters_are_connected(texture):
	get_node("Sprite").set_texture(texture)

func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		OtterStats.set_can_see_teleporter(true)
		if Input.is_action_just_pressed("info"):
			dialogPlayer.play_dialog("TeleporterInfoBox")
	else:
		OtterStats.set_can_see_teleporter(false)
		dialogPlayer.stop_dialog()

func _on_Hurtbox_area_entered(_area):
	if !is_gray_phone_booth():
		return

	update_teleporter_state()

	if all_red_teleporters_are_same_color():
		TeleporterState.are_red_teleporters_connected = true
	elif all_blue_teleporters_are_same_color():
		TeleporterState.are_blue_teleporters_connected = true
	else:
		update_teleporter_color()

func is_gray_phone_booth():
	return (get_node("Sprite").get_texture().get_path() ==
	"res://Teleporter/GrayPhoneBooth/PhoneBoothGray.png")

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
		color = "red"
		set_red_teleporter_color()
	else:
		color = "blue"
		set_blue_teleporter_color()

func set_red_teleporter_color():
	get_node("Sprite").set_texture(redClosed)

func set_blue_teleporter_color():
	get_node("Sprite").set_texture(blueClosed)

func handle_red_bit_fired():
	OtterStats.red_bits -= 1
	TeleporterState.current_bit_color = UTIL.RED
	TeleporterState.num_red_teleporters += 1
	TeleporterState.activeTeleporters.append([self, 'red'])
	color = 'red'

func handle_blue_bit_fired():
	OtterStats.blue_bits -= 1
	TeleporterState.current_bit_color = UTIL.BLUE
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
	color = 'gray'

func _on_InteractableHurtbox_area_entered(area):
	if !TeleporterState.are_all_teleporters_connected() or area.owner.stats.isEncoded == true:
		return
	
	if !([self, color] in TeleporterState.activeTeleporters):
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


