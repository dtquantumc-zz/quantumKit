extends Node2D

# Current Level Setter for each level
# Note: used since Playing a scene via F6 doesn't properly set curr_level

export(int) var ActualSceneNumber : int = 2

# Called when the node enters the scene tree for the first time.
# Sets the level of the scene if there's a mismatch
func _ready():
	if (OtterStats.curr_level != ActualSceneNumber):
		print("[BackupSceneInformationSetter]:  Current level " + str(OtterStats.curr_level) + " mismatch with " + str(ActualSceneNumber) + "!")
		OtterStats.set_level_no_signal(ActualSceneNumber)

