extends Control

onready var audioStreamPlayer = $AudioStreamPlayer

func start_music():
	audioStreamPlayer.play()