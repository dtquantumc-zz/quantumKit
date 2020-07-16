extends Node2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player
func _physics_process(_delta):
	var story = "res://Stories/InfoBoxesBakedStory.tres"

	if playerDetectionZone.can_see_player():
		OtterStats.set_can_see_encoder(true)
		if Input.is_action_just_pressed("info"):
			dialogPlayer.play_dialog("EncoderInfoBox")
	else:
		OtterStats.set_can_see_encoder(false)
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
	if (_area.owner.followers.size() >= 1 and _area.owner.stats.isEncoded):
		create_decoder_effect(_area.owner)
		queue_free()
