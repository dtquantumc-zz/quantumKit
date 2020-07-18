extends Node2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

var decoder_used = false

func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		OtterStats.set_can_see_decoder(true)
		if Input.is_action_just_pressed("info") || !InfoDialogState.get_has_decoder_dialog_been_seen():
			dialogPlayer.play_dialog("DecoderInfoBox")

		if !InfoDialogState.get_has_decoder_dialog_been_seen():
			InfoDialogState.set_has_decoder_dialog_been_seen(true)
	else:
		OtterStats.set_can_see_decoder(false)
		dialogPlayer.stop_dialog()

func create_decoder_effect(toTeleport):
	var DecoderEffect = load("res://Effects/DecoderEffect.tscn")
	var decoderEffect = DecoderEffect.instance()
	var world = get_tree().current_scene
	world.add_child(decoderEffect)
	decoderEffect.global_position = global_position
	decoderEffect.connectTeleport( toTeleport )

func _on_Hurtbox_area_entered(_area):
#	print(_area.owner.followers)
	if (!decoder_used and _area.owner.followers.size() >= 1 and _area.owner.stats.isEncoded):
		create_decoder_effect(_area.owner)
		CustomSignals.emit_signal("decoder_used")
		decoder_used = true
