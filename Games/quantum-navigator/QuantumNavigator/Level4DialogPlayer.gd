extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		if OtterStats.curr_level == 3:
			if Input.is_action_just_pressed("info") || !InfoDialogState.get_has_decoherence_dialog_been_seen():
				dialogPlayer.play_dialog("DecoherenceInfoBox")

			if !InfoDialogState.get_has_decoherence_dialog_been_seen():
				InfoDialogState.set_has_decoherence_dialog_been_seen(true)
		if OtterStats.curr_level == 4:
			if Input.is_action_just_pressed("info") || !InfoDialogState.get_has_superposition_dialog_been_seen():
				dialogPlayer.play_dialog("SuperpositionInfoBox")

			if !InfoDialogState.get_has_superposition_dialog_been_seen():
				InfoDialogState.set_has_superposition_dialog_been_seen(true)
	else:
		dialogPlayer.stop_dialog()
