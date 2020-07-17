extends Node2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		OtterStats.set_can_see_encoder(true)
		if Input.is_action_just_pressed("info"):
			dialogPlayer.play_dialog("EncoderInfoBox")
	else:
		OtterStats.set_can_see_encoder(false)
		dialogPlayer.stop_dialog()

func create_computer_effect(toTeleport):
	var ComputerEffect = load("res://Effects/ComputerEffect.tscn")
	var computerEffect = ComputerEffect.instance()
	var world = get_tree().current_scene
	world.add_child(computerEffect)
	computerEffect.global_position = global_position
	computerEffect.connectTeleport( toTeleport )

func _on_Hurtbox_area_entered(_area):
#	print(_area.owner.stats.pickles)
	if (_area.owner.stats.pickles >= 2):
		_area.owner.stats.pickles -= 2
		create_computer_effect(_area.owner)
		queue_free()
