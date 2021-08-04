extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	OtterStats.connect("level2_state_changed", self, "_on_level_state_changed")

func _on_level_state_changed(state):
	if self.name == "light1":
		self.light.visible = state[0]
