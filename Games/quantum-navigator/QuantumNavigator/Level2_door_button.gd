extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var buttonsprite = $button_sprite
var up_button = preload("res://Assets/StaticButton.png")
var pressed_button = preload("res://Assets/StaticPushedButton.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	OtterStats.connect("level2_state_changed", self, "_on_level_state_changed")
	buttonsprite.set_texture(up_button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_level_state_changed(state):
	pass
	
func _on_DoorButton1_area_entered(area):
	var game_state = OtterStats.level2_state

	if self.name == "doorbutton1":
		game_state[0] = (game_state[0] + 1) % 3
		game_state[1] = (game_state[1] + 1) % 3
	if self.name == "doorbutton2":
		game_state[1] = (game_state[1] + 1) % 3
		game_state[2] = (game_state[2] + 1) % 3
	if self.name == "doorbutton3":
		game_state[2] = (game_state[2] + 1) % 3
		game_state[0] = (game_state[0] + 1) % 3
		
	buttonsprite.set_texture(pressed_button)
	OtterStats.set_level2_state(game_state)




func _on_DoorButton1_area_exited(area):
	buttonsprite.set_texture(up_button)
