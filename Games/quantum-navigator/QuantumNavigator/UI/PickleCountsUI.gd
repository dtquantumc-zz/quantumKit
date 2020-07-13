extends Control

var pickles = 0 setget set_pickles

onready var label = $Label

func set_pickles(value):
	pickles = max(value, 0)
	if label != null:
		label.text = str(pickles)

func _ready():
	self.pickles = OtterStats.pickles
	OtterStats.connect("pickles_changed", self, "set_pickles")
