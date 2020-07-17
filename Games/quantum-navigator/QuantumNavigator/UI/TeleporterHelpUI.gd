extends Control

var teleporter_visible = {} setget set_teleporter_visible

onready var icon = $Icon
onready var label = $Label

func set_teleporter_visible(dict):
	teleporter_visible[dict.name] = dict.value

	if teleporter_visible.values().has(true):
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
