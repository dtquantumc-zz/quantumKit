extends Node2D

# Script to be attached to the scenes that play the starting/ending videos



# export allows the value to be modified in inspector with type specified
## Array of VideoStream objects to be loaded sequentially
export(Array,VideoStream) var Videos : Array = []
## Delay before switching videos after last frame of previous video reached
export(int) var SwitchDelay : int = 0
## Next scene to load after all videos complete
## if null, quits the game
export(PackedScene) var NextScene : PackedScene = null

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var VideoPlayerObject = $VideoPlayer
onready var Timer = $Timer

# Current playing index
var index = -1

# Called when the node enters the scene tree for the first time.
# Plays the first video in the list of videos, if one exists
func _ready():
	if (Videos.size() > 0):
		VideoPlayerObject.stream = Videos[0]
		VideoPlayerObject.play()
		index = 0

func _process(_delta):
	if (Input.is_action_just_pressed("push")):
		_on_VideoPlayer_finished()

# Runs upon video player finish - starts playing the next video if SwitchDelay
# is zero, or starts a timer for the next video to play otherwise
func _on_VideoPlayer_finished():
	index += 1
	if SwitchDelay > 0:
		Timer.wait_time = SwitchDelay
		Timer.start()
	else:
		play_current_index()

# Plays the video at the current index, or if index too great, switches scenes
# or exists the game
func play_current_index():
	if (index < Videos.size()):
		VideoPlayerObject.stream = Videos[index]
		VideoPlayerObject.play()
	elif NextScene != null:
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(NextScene)
		OtterStats.set_level(1)
	else:
		get_tree().quit()

# Runs upon timer reaching 0 - calls play_current_index
func _on_Timer_timeout():
	play_current_index()
