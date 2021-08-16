extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	OtterStats.connect("keys_changed", self, "set_keys")
	
func set_keys(value):
	$keys.text = str(value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
