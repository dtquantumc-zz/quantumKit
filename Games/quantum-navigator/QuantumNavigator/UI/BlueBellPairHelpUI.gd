extends Control

var blue_bell_pair_visible = {} setget set_blue_bell_pair_visible

onready var icon = $Icon
onready var label = $Label

func set_blue_bell_pair_visible(dict):
	blue_bell_pair_visible[dict.name] = dict.value

	if blue_bell_pair_visible.values().has(true):
		icon.rect_size.x = 28
		icon.rect_size.y = 14
		label.set_percent_visible(1)
	else:
		icon.rect_size.x = 0
		icon.rect_size.y = 0
		label.set_percent_visible(0)

func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("blue_bell_pair_visible", self, "set_blue_bell_pair_visible")


