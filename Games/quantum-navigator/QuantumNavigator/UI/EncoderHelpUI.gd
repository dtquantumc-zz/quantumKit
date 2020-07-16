extends Control

var encoder_visible = false setget set_encoder_visible

onready var icon = $Icon
onready var label = $Label

func set_encoder_visible(value):
	encoder_visible = value

	if encoder_visible:
		icon.rect_size.x = 64
		icon.rect_size.y = 64
		label.set_percent_visible(1)
	else:
		icon.rect_size.x = 0
		icon.rect_size.y = 0
		label.set_percent_visible(0)

func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("encoder_visible", self, "set_encoder_visible")


