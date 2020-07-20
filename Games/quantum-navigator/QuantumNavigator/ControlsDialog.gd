extends Node2D

onready var dialogPlayer = $Dialog_Player

func _physics_process(_delta):
	if Input.is_action_just_pressed("controls") && !InfoDialogOpenState.get_is_info_dialog_open():
		dialogPlayer.play_dialog("GameControlsInfoBox")
