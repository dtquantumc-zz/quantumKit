extends Control

# Script to be attached to the UI displaying the number of keys

# Called when the node enters the scene tree for the first time.
# Attaches a listener to a change in the number of keys
func _ready():
	# warning-ignore:return_value_discarded
	OtterStats.connect("keys_changed", self, "set_keys")

# Sets the displayed number of keys
func set_keys(value : int):
	$keys.text = str(value)
