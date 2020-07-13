extends Area2D

const UTIL = preload("res://Utility.gd")

func _ready():
	CustomSignals.connect("entanglement_bit_collision", self, "on_impact")

func on_impact(color_of_colliding_bit):
	if color_of_colliding_bit == UTIL.RED:
		var connectedRedTeleporter = load("res://Teleporter/RedPhoneBooth/PhoneBoothClosed.png")
		self.get_node("Sprite").set_texture(connectedRedTeleporter)
	else:
		var connectedBlueTeleporter = load("res://Teleporter/BluePhoneBooth/PhoneBoothClosed.png")
		get_node("Sprite").set_texture(connectedBlueTeleporter)