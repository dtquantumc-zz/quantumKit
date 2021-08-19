extends Node2D

export(Array,VideoStream) var Videos : Array = []
export(int) var SwitchDelay : int = 1
export(PackedScene) var NextScene : PackedScene = null

onready var VideoPlayerObject = $VideoPlayer
onready var Timer = $Timer
var index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	if (Videos.size() > 0):
		VideoPlayerObject.stream = Videos[0]
		VideoPlayerObject.play()
		index = 0

func _on_VideoPlayer_finished():
	index += 1
	if SwitchDelay > 0:
		Timer.wait_time = SwitchDelay
		Timer.start()
	else:
		play_current_index()

func play_current_index():
	if (index < Videos.size()):
		VideoPlayerObject.stream = Videos[index]
		VideoPlayerObject.play()
	elif NextScene != null:
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(NextScene)
	else:
		get_tree().quit()

func _on_Timer_timeout():
	play_current_index()
