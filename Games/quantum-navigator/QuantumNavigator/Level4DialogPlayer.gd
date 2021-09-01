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
		if Input.is_action_just_pressed("info") || !InfoDialogState.get_has_superposition_dialog_been_seen():
			dialogPlayer.play_dialog("SuperpositionInfoBox")

		if !InfoDialogState.get_has_superposition_dialog_been_seen():
			InfoDialogState.set_has_superposition_dialog_been_seen(true)
	else:
		dialogPlayer.stop_dialog()
