extends Control

var teleporter_visible = false setget set_teleporter_visible

onready var icon = $Icon
onready var label = $Label

func set_teleporter_visible(value):
	teleporter_visible = value

	if teleporter_visible:
		icon.rect_size.x = 25
		icon.rect_size.y = 52
		label.set_percent_visible(1)
	else:
		icon.rect_size.x = 0
		icon.rect_size.y = 0
		label.set_percent_visible(0)

func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("teleporter_visible", self, "set_teleporter_visible")