extends Control

var red_bell_pair_visible = {} setget set_red_bell_pair_visible

onready var icon = $Icon
onready var label = $Label

func set_red_bell_pair_visible(dict):
	red_bell_pair_visible[dict.name] = dict.value
	if red_bell_pair_visible.values().has(true):
		icon.rect_size.x = 28
		icon.rect_size.y = 14
		label.set_percent_visible(1)
	else:
		icon.rect_size.x = 0
		icon.rect_size.y = 0
		label.set_percent_visible(0)

func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("red_bell_pair_visible", self, "set_red_bell_pair_visible")
